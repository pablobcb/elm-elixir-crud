# Installing Dependencies
## Elixir
  `sudo touch /etc/init.d/couchdb`
  Instructions [`here`](http://elixir-lang.org/install.html)
  
## Phoenix
  Instrunctions [`here`](http://www.phoenixframework.org/docs/installation)
## Erlang   
  `sudo apt-get install erlang erlang-dev`
## Phoenix 
  `apt-get install inotify-tools`
  `mix deps.get`
## es2015
`npm install babel-preset-es2015`
# Running 
`mix phoenix.server`
Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
# Migrating
`mix ecto.migrate`

#todo
criar cron pra apagar requests mais velhos que 1 semana

criar cron que manda email de resetar senha

criar template de email

criar cron criar cron que manda email de novo usuario