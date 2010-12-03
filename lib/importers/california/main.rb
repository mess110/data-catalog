class Importers
  class California

    def self.fetch
    end

    def self.process
    end

    def self.store
      DataLoader.new(
        :model_path => File.expand_path('..', __FILE__),
        :verbosity  => 1
      ).run
    end

  end
end
