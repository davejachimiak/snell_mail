class JoinTable
  attr_reader :ass_strings, :column_names

  HABTM = 'has_and_belongs_to_many'

  def detect_habtm_rel
    models_dir  = Dir.open('app/models')
    model_files = models_dir.select { |f| f if /.rb$/.match(f) }

    @ass_strings = {}

    model_files.each do |file_name|
      file = File.open("app/models/#{file_name}", 'r')
      if has_habtm?(file)
	file = File.open("app/models/#{file_name}", 'r')
        file.each do |line|
          if line.include?(HABTM) && !line.include?('#')
            @ass_strings[file_name.gsub('.rb', '')] = line.gsub(HABTM,'').gsub(':','').gsub(' ', '').gsub("\n", '')
          end
        end
      end
    end
  end

  def model_match?
    keys = ass_strings.keys
    values = ass_strings.values

    truth = keys.map { |k| values.include?(k.pluralize) ? true : false }
    if truth[0] == true && truth[1] == true
      @column_names = [values[0], values[1]].sort
    else
      false
    end
  end

  def build_migrations
    file = File.new("db/migrate/" + Time.now.to_s.gsub('-', '').gsub(' ', '').gsub(':', '')[0..-5] +
                    "_create_#{column_names[0]}_#{column_names[1]}.rb", 'w+')
    file.write("class Create#{column_names[0].capitalize}#{column_names[1].capitalize} < ActiveRecord::Migration\n" + 
               "  def change\n" +
               "    create_table :#{column_names[0]}_#{column_names[1]}, :id => false do |t|\n" +
               "      t.string :#{column_names[0].singularize}_id, :null => false\n" +
               "      t.string :#{column_names[1].singularize}_id, :null => false\n" +
               "    end\n" +
               "  end\n" +
               "end")
    file.close
  end

  def migrate
    %x[rake db:migrate]
  end

  def has_habtm?(file)
    file.read.include?(HABTM)
  end
end
