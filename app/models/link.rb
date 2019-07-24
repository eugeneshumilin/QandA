class Link < ApplicationRecord
  URL_FORMAT = /(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})/
  GIST_HOST = 'gist.github.com'

  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: { with: URL_FORMAT, message:'please enter correct link' }

  def is_gist?
    URI(url).host == GIST_HOST
  end

  def gist_content
    client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
    gist = client.gist(url.split("/").last)
    file = {}
    gist.files.each { |_, v| file = v.content }
    file
  end
end
