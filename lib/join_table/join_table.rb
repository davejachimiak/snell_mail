class join_table
  HABTM = 'has_and_belongs_to_many'

  def detect_habtm_rel
    models_dir  = Dir.open('app/models')
    model_files = models_dir.select { |f| File.open(f, 'r') if /.rb$/.match(f) }

    ass_strings = []

    model_files.each do |file|
      if has_habtm?(file)
        file.each do |line|
          if line.include?(HABTM)
            ass_strings << line.gsub(HABTM + ' ','').gsub(':','')
          end
        end
      end
    end
  end

  def has_habtm?(file)
    file.read.include?(HABTM)
  end
end