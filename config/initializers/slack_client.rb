require 'slack-client'

SLACK_CLIENT = Slack::Web::Client.new(token: ENV["SLACK_BOT_TOKEN"])
