web: rails s
worker: bundle exec sidekiq -q high -q default -q low
release: rake db:migrate
