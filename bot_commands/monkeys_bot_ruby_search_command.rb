require 'slack-ruby-bot'
require_relative 'monkeys_bot'
require_relative '../ruby_doc'

##
# The idea of this feature is when a user say monkeys ruby #{command} it will go to
# Ruby Doc web site and take a screenshot of found info and then post it into a channel.
# There might be multiple records which will require to provide more specific data.
#
# ***************
# Example:
# monkeys ruby gsub
#
# monkeys: Multiple records found. Please repeat query to get the one you are interesting in:
#
# monkeys ruby gsub (Kernel)
# monkeys ruby gsub (String)
# monkeys ruby gsub! (String)
#
# ***************
#
#
class RubyCommand < MonkeysBot

  command('ruby')
  command('Ruby')
  command('RUBY')

  @reply = nil

  SCREENSHOT = Dir[File.join(File.dirname(__FILE__),"../screenshot/*.png")].each {|file| require file }

  ##
  # client - The client argument is a Slack client object that enables all communications of your bot
  # data - The data argument is a hash that stores all the information about the incoming commands
  # match -  At last, the _match argument is an object that contains data about the command in a more structured way
  #
  # match attribute container example:
  # #<MatchData "<@BOT_ID> list ruby" bot:"<@BOT_ID>" command:"list" expression:"ruby">
  #
  def self.call(client, data, match)
    search_phrase = match[:expression]
    self.do_search(search_phrase)
    if @reply.is_a?(Array)
      client.say(channel: data.channel, text: "There were several records found. Choose one of following and try ruby <comand> again.")
      @reply.each do |element|
        client.say(channel: data.channel, text: "ruby #{ element }")
      end
    end
  end

  ##
  # TODO: Update this one to firefox headless and test if it works in Raspberian!
  #
  def self.do_search(search_phrase)
    ruby_doc = self.add_driver
    ruby_doc.goto
    @reply = ruby_doc.search_for_method(search_phrase)
    ruby_doc.tear_down
  end

  def self.add_driver
    RubyDocs.new
  end
end