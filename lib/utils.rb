# frozen_string_literal: true

module Utils
  module_function

  def octokit
    @octokit ||= Octokit::Client.new(access_token: ENV.fetch('GITHUB_TOKEN'))
  end
end
