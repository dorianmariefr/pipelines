class Application < ApplicationRecord
  MASTODON = "mastodon"

  KINDS = [MASTODON]

  validates :kind, inclusion: {in: KINDS}
  validates :domain, presence: true
  validates :client_id, presence: true
  validates :client_secret, presence: true
end
