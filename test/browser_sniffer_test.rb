require 'test_helper'

class BrowserSnifferTest < MiniTest::Unit::TestCase
  AGENTS = {
    :ipad_old => {
      :user_agent => "Mozilla/5.0(iPad; U; CPU iPhone OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B314 Safari/531.21.10",
      :form_factor => :tablet,
      :ios? => true,
      :android? => false,
      :desktop? => false,
      :engine => :webkit,
      :major_engine_version => 531,
      :os => :ios,
      :os_version => '3.2',
      :browser => :safari,
      :major_browser_version => 4
    },
    :ipad_new => {
      :user_agent => "Mozilla/5.0 (iPad; U; CPU OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B334b Safari/531.21.10",
      :form_factor => :tablet,
      :ios? => true,
      :android? => false,
      :desktop? => false,
      :engine => :webkit,
      :major_engine_version => 531,
      :os => :ios,
      :os_version => '3.2',
      :browser => :safari,
      :major_browser_version => 4
    },
    :ipad_chrome => {
      :user_agent => "Mozilla/5.0 (iPad; CPU OS 6_0_1 like Mac OS X; en-us) AppleWebKit/534.46.0 (KHTML, like Gecko) CriOS/21.0.1180.82 Mobile/10A523 Safari/7534.48.3",
      :form_factor => :tablet,
      :ios? => true,
      :android? => false,
      :desktop? => false,
      :engine => :webkit,
      :major_engine_version => 534,
      :os => :ios,
      :os_version => '6.0.1',
      :browser => :chrome,
      :major_browser_version => 21
    },
    :iphone => {
      :user_agent => "Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_1_2 like Mac OS X; en-us) AppleWebKit/528.18 (KHTML, like Gecko) Version/4.0 Mobile/7D11 Safari/528.16",
      :form_factor => :handheld,
      :ios? => true,
      :android? => false,
      :desktop? => false,
      :engine => :webkit,
      :major_engine_version => 528,
      :os => :ios,
      :os_version => '3.1.2',
      :browser => :safari,
      :major_browser_version => 4
    },
    :ipod_touch => {
      :user_agent => "Mozilla/5.0 (iPod; U; CPU iPhone OS 2_2_1 like Mac OS X; en-us) AppleWebKit/525.18.1 (KHTML, like Gecko) Version/3.1.1 Mobile/5H11a Safari/525.20",
      :form_factor => :handheld,
      :ios? => true,
      :android? => false,
      :desktop? => false,
      :engine => :webkit,
      :major_engine_version => 525,
      :os => :ios,
      :os_version => '2.2.1',
      :browser => :safari,
      :major_browser_version => 3
    },
    :nexus_one => {
      :user_agent => "Mozilla/5.0 (Linux; U; Android 2.2; en-us; Nexus One Build/FRF91) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1",
      :form_factor => :handheld,
      :ios? => false,
      :android? => true,
      :desktop? => false,
      :engine => :webkit,
      :major_engine_version => 533,
      :os => :android,
      :os_version => '2.2',
      :browser => :safari,
      :major_browser_version => 4
    },
    :htc_droid => {
      :user_agent => "Mozilla/5.0 (Linux; U; Android 2.2; nl-nl; Desire_A8181 Build/FRF91) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1",
      :form_factor => :handheld,
      :ios? => false,
      :android? => true,
      :desktop? => false,
      :engine => :webkit,
      :major_engine_version => 533,
      :os => :android,
      :os_version => '2.2',
      :browser => :safari,
      :major_browser_version => 4
    },
    :bb_torch => {
      :user_agent => "Mozilla/5.0 (BlackBerry; U; BlackBerry 9800; en) AppleWebKit/534.1+ (KHTML, Like Gecko) Version/6.0.0.141 Mobile Safari/534.1+",
      :form_factor => :handheld,
      :ios? => false,
      :android? => false,
      :desktop? => false,
      :engine => :webkit,
      :major_engine_version => 534,
      :os => :blackberry,
      :os_version => nil,
      :browser => :safari,
      :major_browser_version => 6
    },
    :bb_8830 => {
      :user_agent => "BlackBerry8330/4.3.0 Profile/MIDP-2.0 Configuration/CLDC-1.1 VendorID/105",
      :form_factor => :handheld,
      :ios? => false,
      :android? => false,
      :desktop? => false,
      :engine => nil,
      :major_engine_version => nil,
      :os => :blackberry,
      :os_version => '4.3.0',
      :browser => nil,
      :major_browser_version => nil
    },
    :kindle => {
      :user_agent => "Mozilla/4.0 (compatible; Linux 2.6.22) NetFront/3.4 Kindle/2.0 (screen 600x800)",
      :form_factor => :tablet,
      :ios? => false,
      :android? => false,
      :desktop? => false,
      :engine => nil,
      :major_engine_version => 3,
      :os => :linux,
      :os_version => '2.6.22',
      :browser => nil,
      :major_browser_version => 2
    },
    :nokia_classic => {
      :user_agent => "Nokia3120Classic/2.0 (06.20) Profile/MIDP-2.1 Configuration/CLDC-1.1",
      :form_factor => :handheld,
      :ios? => false,
      :android? => false,
      :desktop? => false,
      :engine => nil,
      :major_engine_version => nil,
      :os => nil,
      :os_version => nil,
      :browser => nil,
      :major_browser_version => nil
    },
    :nokia_3200 => {
      :user_agent => "Nokia3200/1.0 (5.29) Profile/MIDP-1.0 Configuration/CLDC-1.0\nUP.Link/6.3.1.13.0",
      :form_factor => :handheld,
      :ios? => false,
      :android? => false,
      :desktop? => false,
      :engine => nil,
      :major_engine_version => nil,
      :os => nil,
      :os_version => nil,
      :browser => nil,
      :major_browser_version => nil
    },
    :att => {
      :user_agent => "Opera/9.51 Beta (Microsoft Windows; PPC; Opera Mobi/1718; U; en)",
      :form_factor => :handheld,
      :ios? => false,
      :android? => false,
      :desktop? => false,
      :engine => nil,
      :major_engine_version => nil,
      :os => :windows,
      :os_version => nil,
      :browser => :opera,
      :major_browser_version => 9
    },
    :benq => {
      :user_agent => "BenQ-CF61/1.00/WAP2.0/MIDP2.0/CLDC1.0 UP.Browser/6.3.0.4.c.1.102 (GUI) MMP/2.0",
      :form_factor => :handheld,
      :ios? => false,
      :android? => false,
      :desktop? => false,
      :engine => nil,
      :major_engine_version => nil,
      :os => nil,
      :os_version => nil,
      :browser => nil,
      :major_browser_version => nil
    },
    :dell_streak => {
      :user_agent => "Mozilla/5.0 (Linux; U; Android 1.6; en-gb; Dell Streak Build/Donut AppleWebKit/528.5+ (KHTML, like Gecko) Version/3.1.2 Mobile Safari/ 525.20.1",
      :form_factor => :tablet,
      :ios? => false,
      :android? => true,
      :desktop? => false,
      :engine => :webkit,
      :major_engine_version => 528,
      :os => :android,
      :os_version => '1.6',
      :os => :android,
      :major_browser_version => 3
    },
    :hp_ipaq => {
      :user_agent => "Mozilla/4.0 (compatible; MSIE 4.01; Windows CE; PPC; 240x320; HP iPAQ h6300)",
      :form_factor => :handheld,
      :ios? => false,
      :android? => false,
      :desktop? => false,
      :engine => nil,
      :major_engine_version => nil,
      :os => :windows,
      :os_version => 'CE',
      :browser => :ie,
      :major_browser_version => 4
    },
    :nintendo_ds => {
      :user_agent => "Mozilla/4.0 (compatible; MSIE 6.0; Nitro) Opera 8.50 [en Mozilla/4.0 (compatible; MSIE 6.0; Nitro) Opera 8.50 [ja]",
      :form_factor => :console,
      :ios? => false,
      :android? => false,
      :desktop? => false,
      :engine => nil,
      :major_engine_version => nil,
      :os => nil,
      :os_version => nil,
      :browser => :opera,
      :major_browser_version => 8
    },
    :firefox_linux => {
      :user_agent => "Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.2.8) Gecko/20100723 Ubuntu/10.04 (lucid) Firefox/3.6.8",
      :form_factor => :desktop,
      :ios? => false,
      :android? => false,
      :desktop? => true,
      :engine => :gecko,
      :major_engine_version => 1,
      :os => :linux,
      :os_version => '10.04',
      :browser => :firefox,
      :major_browser_version => 3
    },
    :safari_mac => {
      :user_agent => "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_3; en-ca) AppleWebKit/534.6+ (KHTML, like Gecko) Version/5.0 Safari/533.16",
      :form_factor => :desktop,
      :ios? => false,
      :android? => false,
      :desktop? => true,
      :engine => :webkit,
      :major_engine_version => 534,
      :os => :mac,
      :os_version => '10.6.3',
      :browser => :safari,
      :major_browser_version => 5
    },
    :chrome_mac => {
      :user_agent => "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_3; en-US) AppleWebKit/534.6 (KHTML, like Gecko) Chrome/6.0.495.0 Safari/534.6",
      :form_factor => :desktop,
      :ios? => false,
      :android? => false,
      :desktop? => true,
      :engine => :webkit,
      :major_engine_version => 534,
      :os => :mac,
      :os_version => '10.6.3',
      :browser => :chrome,
      :major_browser_version => 6
    },
    :chrome_win => {
      :user_agent => "Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US) AppleWebKit/533.4 (KHTML, like Gecko) Chrome/5.0.375.125 Safari/533.4",
      :form_factor => :desktop,
      :ios? => false,
      :android? => false,
      :desktop? => true,
      :engine => :webkit,
      :major_engine_version => 533,
      :os => :windows,
      :os_version => 'Vista',
      :browser => :chrome,
      :major_browser_version => 5
    },
    :ie9 => {
      :user_agent => "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)",
      :form_factor => :desktop,
      :ios? => false,
      :android? => false,
      :desktop? => true,
      :engine => :trident,
      :major_engine_version => 5,
      :os => :windows,
      :os_version => '7',
      :browser => :ie,
      :major_browser_version => 9
    },
    :ie8 => {
      :user_agent => "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; MDDC)",
      :form_factor => :desktop,
      :ios? => false,
      :android? => false,
      :desktop? => true,
      :engine => :trident,
      :major_engine_version => 4,
      :os => :windows,
      :os_version => '7',
      :browser => :ie,
      :major_browser_version => 8
    },
    :ie7 => {
      :user_agent => "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; GTB6.4; .NET CLR 1.1.4322; FDM; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)",
      :form_factor => :desktop,
      :ios? => false,
      :android? => false,
      :desktop? => true,
      :engine => nil,
      :major_engine_version => nil,
      :os => :windows,
      :os_version => 'XP',
      :browser => :ie,
      :major_browser_version => 7
    },
    :opera_win => {
      :user_agent => "Opera/9.80 (Windows NT 6.1; U; en) Presto/2.5.24 Version/10.54",
      :form_factor => :desktop,
      :ios? => false,
      :android? => false,
      :desktop? => true,
      :engine => :presto,
      :major_engine_version => 2,
      :os => :windows,
      :os_version => '7',
      :browser => :opera,
      :major_browser_version => 9
    },
    :wii => {
      :user_agent => "Opera/9.00 (Nintendo Wii; U; ; 1038-58; Wii Shop Channel/1.0; en)",
      :form_factor => :console,
      :ios? => false,
      :android? => false,
      :desktop? => false,
      :engine => nil,
      :major_engine_version => nil,
      :os => nil,
      :os_version => 'Wii',
      :browser => :opera,
      :major_browser_version => 9
    },
    :springboard_launched_ipod_browser => {
      :user_agent => "Mozilla/5.0 (iPod; U; CPU iPhone OS 4_3_3 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Mobile/8J2",
      :form_factor => :handheld,
      :ios? => true,
      :android? => false,
      :desktop? => false,
      :engine => :webkit,
      :major_engine_version => 533,
      :os => :ios,
      :os_version => '4.3.3',
      :browser => nil,
      :major_browser_version => 533
    },
    :ipod_os_4_3_3 => {
      :user_agent => "Mozilla/5.0 (iPod; U; CPU iPhone OS 4_3_3 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5",
      :form_factor => :handheld,
      :ios? => true,
      :android? => false,
      :desktop? => false,
      :engine => :webkit,
      :major_engine_version => 533,
      :os => :ios,
      :os_version => '4.3.3',
      :browser => :safari,
      :major_browser_version => 5
    },
    :iphone_4S => {
      :user_agent => "Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3",
      :form_factor => :handheld,
      :ios? => true,
      :android? => false,
      :desktop? => false,
      :engine => :webkit,
      :major_engine_version => 534,
      :os => :ios,
      :os_version => '5.0',
      :browser => :safari,
      :major_browser_version => 5
    },
    :ipad_ios5 => {
      :user_agent => "Mozilla/5.0 (iPad; CPU OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3",
      :form_factor => :tablet,
      :ios? => true,
      :android? => false,
      :desktop? => false,
      :engine => :webkit,
      :major_engine_version => 534,
      :os => :ios,
      :os_version => '5.0',
      :browser => :safari,
      :major_browser_version => 5
    },
    :excel_mac => {
      :user_agent => "Mozilla/5.0 (Macintosh; Intel Mac OS X) Excel/14.34.0",
      :form_factor => :desktop,
      :ios? => false,
      :android? => false,
      :desktop? => true,
      :engine => nil,
      :major_engine_version => nil,
      :os => :mac,
      :os_version => nil,
      :browser => nil,
      :major_browser_version => nil
    }
  }

  AGENTS.each do |agent, attributes|
    define_method "test_sniff_#{agent}_corrently" do
      sniffer = BrowserSniffer.new(attributes[:user_agent])
      attributes.reject{|attr| attr == :user_agent}.each do |attribute, value|
        assert_equal value, sniffer.send(attribute), "#{attribute.to_s} did not match"
      end
    end
  end
end
