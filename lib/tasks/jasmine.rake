begin
  require 'guard/jasmine/task'

  Guard::JasmineTask.new do |task|
    task.options = '-e test --specdoc failure --verbose true'
  end

rescue LoadError
  # Ignore task on production and asset environment
end
