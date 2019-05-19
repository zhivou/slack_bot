require_relative 'selenium'

##
# This class is working with Ruby Document page, scraping methods and do other stuff for
# Slack-Bot. In future planning to add DB to keep all screenshots in one place(update only if out of date or not found)
#
class RubyDocs

  attr_accessor :version,
                :search_result

  include DriverHelper

  DIR = File.join(File.dirname(__FILE__), "/screenshots/")

  def initialize
    @version = "2.4.2"
    @link = "https://ruby-doc.org/core-#{@version}/"
    @driver = DriverHelper.chrome_local
    @search_result = nil
  end

  def goto
    @driver.navigate.to(@link)
  end

  ##
  # Search for main page. The whole html overlapping by HTML class which makes it imposible to click
  # but all buttons are links - getting href value and using it for redirection
  #
  def search_for_method(name)
    search_xpath = "//div[@id='class-index']/div[2]/p/a[contains(text(),'#{name}')] | //div[@id='method-index']/div[2]/p/a[contains(text(),'#{name}')]"

    #
    # Nothing is found
    #
    if @driver.find_elements(xpath: search_xpath).empty?
      @search_result = 'Nothing was found!'
    #
    # Returns a container with all records possible. Array
    #
    elsif @driver.find_elements(xpath: search_xpath).length > 1
      @search_result = @driver.find_elements(xpath: search_xpath).map(&:text)
    #
    # A single record was found. Because page is overlapped by some other
    # element it will get the href link and use it for navigation
    #
    else
      link = @driver.find_element(xpath: search_xpath).attribute("href")
      @driver.navigate.to(link)
    end
  end

  ##
  # Checks if folder already have a screenshot.
  # Also checks if screenshot is up to date. Returns a screenshot location
  #
  def search_for_method_in_folder(method_name)
    # add functionality here
  end

  ##
  # Can find multiple elements. Need to grab them all, make a screenshot and resize it to
  # size/location.
  #
  def get_element_screenshot(name)
    xpath = "//span[contains(text(), '#{name}')][@class='method-callseq']/../following-sibling::div"

    #
    # If more then one found will take > 2 screenshot if needed
    #
    if @driver.find_elements(xpath: xpath).length == 1
      element = @driver.find_element(xpath: xpath)
      size = get_element_size(element)
      @driver.manage.window.resize_to(size[0], size[1])
      @driver.action.move_to(element).perform
      screenshot_logger(name)
    else
      @driver.find_elements(xpath: xpath).each do |dom_element|
        size = get_element_size(dom_element)
        @driver.manage.window.resize_to(size[0], size[1])
        @driver.action.move_to(dom_element).perform
        screenshot_logger(name)
      end
    end
  end

  ##
  # Returns X and Y location of provided element
  #
  def get_element_location(element)
    x = element.location.x
    y = element.location.y
    [x,y]
  end

  ##
  # Returns Width and Height of provided element
  #
  def get_element_size(element)
    width = element.size.width
    height = element.size.height
    [width, height]
  end

  ##
  # Saves a screenshot into screenshot folder, also has save delay checker
  #
  def screenshot_logger(element_name)
    before = Dir[File.join(DIR, '**', '*')].count
    file_name = "#{element_name}-#{Time.now}-ruby_doc.png"
    count = 0

    while before >= Dir[File.join(DIR, '**', '*')].count
      @driver.save_screenshot(DIR + file_name)
      sleep 1
      count +=1
      puts "Could not verify that screenshot is taken!" if count >= 30
      break if count >= 30
    end
  end

  def tear_down
    @driver.manage.delete_all_cookies
    @driver.quit
  end
end