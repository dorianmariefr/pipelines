web: rails s
worker: bundle exec sidekiq -q high -q default -q low -c 10
release: rake db:migrate
