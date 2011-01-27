# Copied from rspec.rake in rspec-rails-2.4.1
if defined?(RSpec)
  spec_prereq = Rails.configuration.generators.options[:rails][:orm] == :active_record ? "db:test:prepare" : :noop
  [:lib].each do |sub|
    desc "Run the code examples in spec/#{sub}"
    RSpec::Core::RakeTask.new(sub => spec_prereq) do |t|
      t.pattern = "./spec/#{sub}/**/*_spec.rb"
    end
  end
end
