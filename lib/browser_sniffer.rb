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

  # This method checks ie 11 mobile or ie11 rendering an older version in compatibility mode, in addition to `ie11?`.
  # The `ie11?` method would return false in both those scenarios.
  def ie11_actual?
    ie11_engine = major_engine_version == 7 && engine_name == 'Trident'
    ie_mobile11 = major_browser_version == 11 && browser_name == 'IEMobile'

    ie11? || ie11_engine || ie_mobile11
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

  def same_site_none_compatible?
    return false unless user_agent

    webkit_same_site_compatible? && same_site_recognized_browser?
  end

  def webkit_same_site_compatible?
    return false unless os && os_version && browser

    !(os == :ios && os_version.match(/^([0-9]|1[12])[\.\_]/)) &&
       !(os == :mac && browser == :safari && os_version.match(/^10[\.\_]14/))
  end

  def same_site_recognized_browser?
    return false unless major_browser_version

    !(chromium_based? && major_browser_version >= 51 && major_browser_version <= 66) &&
      !(uc_browser? && !uc_browser_version_at_least?(12, 13, 2))
  end

  def chromium_based?
    browser_name ? browser_name.downcase.match(/chrom(e|ium)/) : false
  end

  def uc_browser?
    user_agent ? user_agent.downcase.match(/uc\s?browser/) : false
  end

  def uc_browser_version_at_least?(major, minor, build)
    return false unless browser_version
    digits = browser_version.split('.').map(&:to_i)
    return false unless digits.count >= 3

    return digits[0] > major if digits[0] != major
    return digits[1] > minor if digits[1] != minor
    digits[2] >= build
  end
end
