require 'selenium-webdriver'

module DriverHelper

  ##
  # FULL. Use this for troubleshooting.
  #
  def self.chrome_local
    capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
        chrome_options: {
            args: ['disable-infobars'],
            detach: true
        }
    )
    client = Selenium::WebDriver::Remote::Http::Default.new(read_timeout: 120)
    @browser = Selenium::WebDriver.for :chrome, desired_capabilities: capabilities, http_client: client
  end

  ##
  # HEADLESS. This one is good for scraping data.
  #
  def self.chrome_local_headless
    capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
        chrome_options: {
            args: ['disable-infobars', 'headless'],
            detach: true
        }
    )
    client = Selenium::WebDriver::Remote::Http::Default.new(read_timeout: 120)
    @browser = Selenium::WebDriver.for :chrome, desired_capabilities: capabilities, http_client: client
  end
end