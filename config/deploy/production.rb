role :app, 'alphagemini.org'
role :web, 'alphagemini.org'

server 'alphagemini.org', user: 'passenger', roles: %w{web app}
