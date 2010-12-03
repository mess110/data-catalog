FOLDERS = Dir[Rails.root.join('lib/importers/*')].map { |x| x.split('/').last }

namespace :import do
  desc 'Import all' # (fetch, process, store)
  task :* => [
    'import:fetch:*',
    'import:process:*',
    'import:store:*'
  ]

  FOLDERS.each do |folder|
    name = folder.gsub('-', '_')
    class_eval <<-END
      desc 'Import #{name}' # (fetch, process, store)
      task :#{name} => [
        'import:fetch:#{name}',
        'import:process:#{name}',
        'import:store:#{name}'
      ]
    END
  end

  # (to HTML)
  namespace :fetch do
    task :* do
      FOLDERS.each do |folder|
        Rake::Task["import:fetch:#{folder.gsub('-', '_')}"].invoke
      end
    end

    FOLDERS.each do |folder|
      name = folder.gsub('-', '_')
      class_eval <<-END
        task :#{name} => :environment do
          require Rails.root.join('lib/importers/#{folder}/main')
          Importers::#{name.camelcase}.fetch
        end
      END
    end
  end

  # (to YML)
  namespace :process do
    task :* do
      FOLDERS.each do |folder|
        Rake::Task["import:process:#{folder.gsub('-', '_')}"].invoke
      end
    end

    FOLDERS.each do |folder|
      name = folder.gsub('-', '_')
      class_eval <<-END
        task :#{name} => :environment do
          require Rails.root.join('lib/importers/#{folder}/main')
          Importers::#{name.camelcase}.process
        end
      END
    end
  end

  # (to database)
  namespace :store do
    task :* do
      FOLDERS.each do |folder|
        Rake::Task["import:store:#{folder.gsub('-', '_')}"].invoke
      end
    end

    FOLDERS.each do |folder|
      name = folder.gsub('-', '_')
      class_eval <<-END
        task :#{name} => :environment do
          require Rails.root.join('lib/importers/#{folder}/main')
          Importers::#{name.camelcase}.store
        end
      END
    end
  end

end
