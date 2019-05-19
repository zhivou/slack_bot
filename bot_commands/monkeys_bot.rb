require 'slack-ruby-bot'

##
# This is a super class of MonkeysBot Integration
#
class MonkeysBot < SlackRubyBot::Bot
  help do
    title 'QA Automation Bot'
    desc 'This bot_commands returns some information regarding QA Automation'

    command 'ruby <method/class>' do
      desc 'Returns a screenshot and link to the Ruby Document location.'
    end

    command 'watchlist add <movie>' do
      desc 'Adds a movie to watch suggested by James into a DB'
    end

    command 'watchlist show' do
      desc 'Will show a list of movies suggested by James'
    end

    command 'watchlist delete <id>' do
      desc 'Will delete a movie based on provided <id>'
    end

    command 'w' do
      desc 'Will delete a movie based on provided <id>'
    end
  end
end
