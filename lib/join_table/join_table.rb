class JoinTable
  attr_reader :ass_strings

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
  
  def build_migrations
    #file = File.new(Time.now.to_s.gsub('-', '').gsub(' ', '').gsub(':', '')[0..-5] +
	"Create#{model_name1}#{model_name2}.rb", 'w+')
	#file.write(migrationstuff)
	#file.close
  end

  def has_habtm?(file)
    file.read.include?(HABTM)
  end
end