begin

  require 'rspec/core/rake_task'

  desc 'Run all specs'
  RSpec::Core::RakeTask.new(:spec)

  desc 'Run all controller specs'
  RSpec::Core::RakeTask.new('spec:controllers') do |t|
    t.pattern = 'spec/controllers/**/*_spec.rb'
  end

  desc 'Run all helper specs'
  RSpec::Core::RakeTask.new('spec:helpers') do |t|
    t.pattern = 'spec/helpers/**/*_spec.rb'
  end

  desc 'Run all mailers specs'
  RSpec::Core::RakeTask.new('spec:mailers') do |t|
    t.pattern = 'spec/mailers/**/*_spec.rb'
  end

  desc 'Run all model specs'
  RSpec::Core::RakeTask.new('spec:models') do |t|
    t.pattern = 'spec/models/**/*_spec.rb'
  end

  desc 'Run all route specs'
  RSpec::Core::RakeTask.new('spec:routes') do |t|
    t.pattern = 'spec/routing/**/*_spec.rb'
  end

  desc 'Run all feature specs'
  RSpec::Core::RakeTask.new('spec:features') do |t|
    t.pattern = 'spec/features/**/*_spec.rb'
  end

  desc 'Run all lib specs'
  RSpec::Core::RakeTask.new('spec:libs') do |t|
    t.pattern = 'spec/lib/**/*_spec.rb'
  end

rescue LoadError
  # Ignore task on production and asset environment
end
