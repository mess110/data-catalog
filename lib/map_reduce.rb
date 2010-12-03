class MapReduce

  def self.load_files(model, method)
    directory = Rails.root.join('app', 'models', model.to_s.underscore, method)
    %w(map reduce).map { |n| File.join(directory, "#{n}.js") }.
      map { |filename| File.read(filename) }
  end

end
