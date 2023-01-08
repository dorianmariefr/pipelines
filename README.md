# README

This README would normally document whatever steps are necessary to get the application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...

```
User.all[-1..].each { |user| pipeline = Pipeline.create!(user: user, name: "Ruby and Rails Hacker News New Stories To Email", published: false); pipeline.sources.create!(kind: "hacker_news/new", filter: 'keywords.include?("Ruby") or keywords.include?("Rails")'); pipeline.destinations.create!(kind: "email", destinable: user.emails.first) }
```
