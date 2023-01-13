class Post < ApplicationRecord
  has_rich_text :description

  def send_later
    Email.find_each do |email|
      EmailMailer
        .with(to: email.email, subject: title, body: description)
        .rich_email
        .deliver_later
    end
  end
end
