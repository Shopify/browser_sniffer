require "browser_sniffer/version"
require "browser_sniffer/patterns"

class BrowserSniffer
  attr_reader :user_agent

  def initialize(user_agent)
    @user_agent = user_agent
  end

  def ios?
    os == :ios
  end

  def android?
    os == :android
  end

  def ie8?
    browser == :ie && major_browser_version == 8
  end

  def ie11?
    browser == :ie && major_browser_version == 11
  end

  def handheld?
    form_factor == :handheld
  end

  def tablet?
    form_factor == :tablet
  end

  def desktop?
    form_factor == :desktop
  end

  def form_factor
    device_info[:type] || :desktop
  end



  def engine
    engine_info[:type]
  end

  def engine_name
    engine_info[:name]
  end

  def major_engine_version
    str = engine_info[:major]
    str && str.to_i
  end

  def engine_version
    engine_info[:version]
  end



  def browser
    browser_info[:type]
  end

  def browser_name
    browser_info[:name]
  end

  def major_browser_version
    str = browser_info[:major]
    str && str.to_i
  end

  def browser_version
    browser_info[:version]
  end



  def device
    device_info[:name]
  end

  def device_name
    device_info[:model]
  end

  def device_vendor
    device_info[:vendor]
  end



  def os
    os_info[:type]
  end

  def os_name
    os_info[:name]
  end

  def os_version
    os_info[:version]
  end



  def browser_info
    @browser_info ||= parse_user_agent_for(BrowserSniffer::REGEX_MAP[:browser])
  end

  def engine_info
    @engine_info ||= parse_user_agent_for(BrowserSniffer::REGEX_MAP[:engine])
  end

  def device_info
    @device_info ||= parse_user_agent_for(BrowserSniffer::REGEX_MAP[:device])
  end

  def os_info
    @os_info ||= parse_user_agent_for(BrowserSniffer::REGEX_MAP[:os])
  end

  def parse_user_agent_for(type)
    result = {}
    type.each_slice(2) do |slice|
      format = slice[1]
      slice[0].each do |regex|
        regex.match(user_agent) do |match|
          format.each_with_index do |field, index|
            if field.class == Symbol
              result[field] = match[index + 1]
            elsif field.class == Array
              if field[1].class == String || field[1].class == Symbol
                result[field[0]] = field[1]
              elsif field[1].class == Hash
                if field[1][match[index + 1]]
                  result[field[0]] = field[1][match[index + 1]]
                else
                  result[field[0]] = match[index + 1]
                end
              elsif field[1].class == Proc
                result[field[0]] = field[1].call(match[index + 1])
              end
            end
          end
          return result
        end
      end
    end
    result
  end
end
