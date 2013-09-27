desc 'Run all tests'
task suite: [:spec, 'guard:jasmine']
