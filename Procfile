web: rails s
worker: bundle exec sidekiq -q high -q default -q low -c 15
release: rake db:migrate
