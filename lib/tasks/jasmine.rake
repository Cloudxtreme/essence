begin
  require 'guard/jasmine/task'

  Guard::JasmineTask.new do |task|
    task.options = '-e test --specdoc failure --verbose true --server-timeout=300'
  end

rescue LoadError
  # Ignore task on production and asset environment
end
