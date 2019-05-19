require 'mysql2'
require 'yaml'

module SQLHelper
  DIR = File.join(File.dirname(__FILE__), "../config")

  ##
  # Establish connection to DB.
  #
  # Uses config/db_config.yml file
  # to know where to connect to. Uses same syntax as ActiveRecords for config file.
  # dir should be dynamic! it won't work if it's not (when including from different location)
  #
  def self.establish_connection
    db_config = YAML::load(File.open(DIR + '/db_config.yml'))
    Mysql2::Client.new(db_config)
  end
end