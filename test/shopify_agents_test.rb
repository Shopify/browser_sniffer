require "test_helper"

describe "Shopify agents" do
  it "Shopify Mobile on iOS can be sniffed" do
    user_agent = "Shopify Mobile/iOS/5.4.4 "\
      "(iPhone9,3/com.jadedpixel.shopify/OperatingSystemVersion(majorVersion: 10, minorVersion: 3, patchVersion: 2))"
    sniffer = BrowserSniffer.new(user_agent)

    assert_equal ({
      name: 'Shopify Mobile',
      version: '5.4.4',
    }), sniffer.browser_info

    assert_equal ({
      type: :handheld,
      model: '9,3',
    }), sniffer.device_info

    assert_equal ({
      type: :ios,
      version: '10.3.2',
      name: 'iOS',
    }), sniffer.os_info

    user_agent = "Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) "\
    "AppleWebKit/ 604.1.21 (KHTML, like Gecko) Version/ 12.0 Mobile/17A6278a Safari/602.1.26 "\
    "MobileMiddlewareSupported Shopify Mobile/iOS/8.12.0 (iPad4,7/com.shopify.ShopifyInternal/12.0.0)"
    sniffer = BrowserSniffer.new(user_agent)

    assert_equal ({
      name: 'Shopify Mobile',
      version: '8.12.0',
    }), sniffer.browser_info

    assert_equal ({
      type: :tablet,
      model: '4,7',
    }), sniffer.device_info

    assert_equal ({
      type: :ios,
      version: '12.0.0',
      name: 'iOS',
    }), sniffer.os_info
  end

  it "Shopify Mobile on iPod touch can be sniffed" do
    user_agent = "Shopify Mobile/iPhone OS/5.4.4 "\
      "(iPod5,1/com.jadedpixel.shopify/OperatingSystemVersion(majorVersion: 9, minorVersion: 3, patchVersion: 5))"
    sniffer = BrowserSniffer.new(user_agent)

    assert_equal ({
      name: 'Shopify Mobile',
      version: '5.4.4',
    }), sniffer.browser_info

    assert_equal ({
      type: :handheld,
      model: '5,1',
    }), sniffer.device_info

    assert_equal ({
      type: :ios,
      version: '9.3.5',
      name: 'iOS',
    }), sniffer.os_info

    user_agent = "Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) "\
    "AppleWebKit/ 604.1.21 (KHTML, like Gecko) Version/ 12.0 Mobile/17A6278a Safari/602.1.26 "\
    "MobileMiddlewareSupported Shopify Mobile/iOS/8.12.0 (iPod5,1/com.shopify.ShopifyInternal/12.0.0)"
    sniffer = BrowserSniffer.new(user_agent)

    assert_equal ({
      name: 'Shopify Mobile',
      version: '8.12.0',
    }), sniffer.browser_info

    assert_equal ({
      type: :handheld,
      model: '5,1',
    }), sniffer.device_info

    assert_equal ({
      type: :ios,
      version: '12.0.0',
      name: 'iOS',
    }), sniffer.os_info
  end

  it "Shopify Mobile on iPhone is detected as handheld" do
    user_agent = "Shopify Mobile/iOS/5.4.4 "\
      "(iPhone9,3/com.jadedpixel.shopify/OperatingSystemVersion(majorVersion: 10, minorVersion: 3, patchVersion: 2))"
    sniffer = BrowserSniffer.new(user_agent)
    assert_equal :handheld, sniffer.form_factor
    assert sniffer.handheld?

    user_agent = "Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) "\
    "AppleWebKit/ 604.1.21 (KHTML, like Gecko) Version/ 12.0 Mobile/17A6278a Safari/602.1.26 "\
    "MobileMiddlewareSupported Shopify Mobile/iOS/8.12.0 (iPhone9,3/com.shopify.ShopifyInternal/12.0.0)"
    sniffer = BrowserSniffer.new(user_agent)
    assert_equal :handheld, sniffer.form_factor
    assert sniffer.handheld?
  end

  it "Shopify Mobile on iPad is detected as tablet" do
    user_agent = "Shopify Mobile/iOS/5.4.4 "\
      "(iPad9,3/com.jadedpixel.shopify/OperatingSystemVersion(majorVersion: 10, minorVersion: 3, patchVersion: 2))"
    sniffer = BrowserSniffer.new(user_agent)
    assert_equal :tablet, sniffer.form_factor
    assert sniffer.tablet?

    user_agent = "Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) "\
    "AppleWebKit/ 604.1.21 (KHTML, like Gecko) Version/ 12.0 Mobile/17A6278a Safari/602.1.26 "\
    "MobileMiddlewareSupported Shopify Mobile/iOS/8.12.0 (iPad9,3/com.shopify.ShopifyInternal/12.0.0)"
    sniffer = BrowserSniffer.new(user_agent)
    assert_equal :tablet, sniffer.form_factor
    assert sniffer.tablet?
  end

  it "Shopify Mobile on iPhone OS is detected as iOS" do
    user_agent = "Shopify Mobile/iPhone OS/5.4.4 "\
      "(iPad2,4/com.jadedpixel.shopify/OperatingSystemVersion(majorVersion: 9, minorVersion: 3, patchVersion: 5))"
    sniffer = BrowserSniffer.new(user_agent)
    assert_equal :ios, sniffer.os
    assert sniffer.ios?

    user_agent = "Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) "\
    "AppleWebKit/ 604.1.21 (KHTML, like Gecko) Version/ 12.0 Mobile/17A6278a Safari/602.1.26 "\
    "MobileMiddlewareSupported Shopify Mobile/iOS/8.12.0 (iPad9,3/com.shopify.ShopifyInternal/12.0.0)"
    sniffer = BrowserSniffer.new(user_agent)
    assert_equal :ios, sniffer.os
    assert sniffer.ios?
  end

  it "Shopify Mobile version is delected on iPhone OS" do
    user_agent = "Shopify Mobile/iOS/6.6.2 (iPhone10,1/com.jadedpixel.shopify/11.0.2)"
    sniffer = BrowserSniffer.new(user_agent)
    assert_equal "6.6.2", sniffer.browser_version
    assert_equal "11.0.2", sniffer.os_version
    assert sniffer.ios?

    user_agent = "Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) "\
    "AppleWebKit/ 604.1.21 (KHTML, like Gecko) Version/ 12.0 Mobile/17A6278a Safari/602.1.26 "\
    "MobileMiddlewareSupported Shopify Mobile/iOS/6.6.2 (iPad9,3/com.shopify.ShopifyInternal/11.0.2)"
    sniffer = BrowserSniffer.new(user_agent)
    assert_equal "6.6.2", sniffer.browser_version
    assert_equal "11.0.2", sniffer.os_version
    assert sniffer.ios?
  end

  it "Shopify Mobile on Android can be sniffed" do
    user_agent = "Shopify Mobile/Android/5.4.4 (Build 12005 with API 25 on OnePlus ONEPLUS A3003)"
    sniffer = BrowserSniffer.new(user_agent)

    assert_equal ({
      name: 'Shopify Mobile',
      version: '5.4.4',
      build: '12005',
      sdk_version: '25',
    }), sniffer.browser_info

    assert_equal ({
      type: :handheld,
      vendor: 'OnePlus',
      model: 'ONEPLUS A3003',
    }), sniffer.device_info

    assert_equal ({
      name: 'Android',
      type: :android,
    }), sniffer.os_info

    user_agent = "Shopify Mobile/Android/8.12.0 (Build 12005 with API 28 on Google Android SDK built for x86) "\
    "MobileMiddlewareSupported Mozilla/5.0 (Linux; Android 9; Android SDK built for x86 Build/PSR1.180720.075; wv) "\
    "AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/69.0.3497.100 Mobile Safari/537.36"
    sniffer = BrowserSniffer.new(user_agent)
    
    assert_equal ({
      name: 'Shopify Mobile',
      version: '8.12.0',
      build: '12005',
      sdk_version: '28',
    }), sniffer.browser_info

    assert_equal ({
      type: :handheld,
      vendor: 'Google',
      model: 'Android SDK built for x86',
    }), sniffer.device_info

    assert_equal ({
      name: 'Android',
      type: :android,
    }), sniffer.os_info
  end

  it "Shopify Mobile on Android simulator can be sniffed" do
    user_agent = "Shopify Mobile/Android/6.2.0 "\
    "(debug) (Build 1 with API 25 on Unknown Android "\
    "SDK built for x86) Mozilla/5.0 (Linux; Android 7.1.1; Android SDK built for x86 Build/NYC; wv) "\
    "AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/55.0.2883.91 Mobile Safari/537.36"
    sniffer = BrowserSniffer.new(user_agent)

    assert_equal ({
      name: 'Shopify Mobile',
      version: '6.2.0 (debug)',
      build: '1',
      sdk_version: '25',
    }), sniffer.browser_info

    assert_equal ({
      name: 'Android',
      type: :android,
    }), sniffer.os_info
  end

  it "Shopify POS on Android MAL can be sniffed" do
    user_agent = "Dalvik/2.1.0 (Linux; U; Android 7.1.1; Android SDK built for x86 Build/NYC) "\
    "Shopify POS 2.4.11.mal/18038"
    sniffer = BrowserSniffer.new(user_agent)

    assert_equal ({
      name: 'Shopify POS',
      version: '2.4.11',
    }), sniffer.browser_info

    assert_equal ({
      name: 'Android',
      type: :android,
      version: '7.1.1',
    }), sniffer.os_info
  end

  it "Shopify POS on iPhone can be sniffed" do
    user_agent = "Shopify POS/3.12.1 (iPhone; iOS 10.3.1; Scale/2.00)"
    sniffer = BrowserSniffer.new(user_agent)

    assert_equal ({
      name: 'Shopify POS',
      version: '3.12.1',
    }), sniffer.browser_info

    assert_equal ({
      type: :handheld,
      scale: '2.00',
    }), sniffer.device_info

    assert_equal ({
      type: :ios,
      version: '10.3.1',
      name: 'iOS',
    }), sniffer.os_info
  end

  it "Shopify POS on iPhone with modern user agent can be sniffed" do
    user_agent = "Shopify POS/iOS/3.12.1 (iPhone10,2/com.jadedpixel.pos/10.3.1)"
    sniffer = BrowserSniffer.new(user_agent)

    assert_equal ({
      name: 'Shopify POS',
      version: '3.12.1',
    }), sniffer.browser_info

    assert_equal ({
      type: :handheld,
      model: '10,2',
    }), sniffer.device_info

    assert_equal ({
      type: :ios,
      version: '10.3.1',
      name: 'iOS',
    }), sniffer.os_info
  end

  it "Shopify POS Next on iPhone with modern user agent can be sniffed" do
    user_agent = "Shopify POS Next/iOS/3.12.1 (iPhone10,2/com.jadedpixel.pos/10.3.1)"
    sniffer = BrowserSniffer.new(user_agent)

    assert_equal ({
      name: 'Shopify POS',
      version: '3.12.1',
    }), sniffer.browser_info

    assert_equal ({
      type: :handheld,
      model: '10,2',
    }), sniffer.device_info

    assert_equal ({
      type: :ios,
      version: '10.3.1',
      name: 'iOS',
    }), sniffer.os_info
  end

  it "Shopify POS on iPod touch can be sniffed" do
    user_agent = "Shopify POS/3.12.1 (iPod touch; iOS 9.3.5; Scale/2.00)"
    sniffer = BrowserSniffer.new(user_agent)

    assert_equal ({
      name: 'Shopify POS',
      version: '3.12.1',
    }), sniffer.browser_info

    assert_equal ({
      type: :handheld,
      scale: '2.00',
    }), sniffer.device_info

    assert_equal ({
      type: :ios,
      version: '9.3.5',
      name: 'iOS',
    }), sniffer.os_info
  end

  it "Shopify POS on iPod touch with modern user agent can be sniffed" do
    user_agent = "Shopify POS/iOS/3.12.1 (iPod5,2/com.jadedpixel.pos/10.3.1)"
    sniffer = BrowserSniffer.new(user_agent)

    assert_equal ({
      name: 'Shopify POS',
      version: '3.12.1',
    }), sniffer.browser_info

    assert_equal ({
      type: :handheld,
      model: '5,2',
    }), sniffer.device_info

    assert_equal ({
      type: :ios,
      version: '10.3.1',
      name: 'iOS',
    }), sniffer.os_info
  end

  it "Shopify POS Next on iPod touch with modern user agent can be sniffed" do
    user_agent = "Shopify POS Next/iOS/3.12.1 (iPod5,2/com.jadedpixel.pos/10.3.1)"
    sniffer = BrowserSniffer.new(user_agent)

    assert_equal ({
      name: 'Shopify POS',
      version: '3.12.1',
    }), sniffer.browser_info

    assert_equal ({
      type: :handheld,
      model: '5,2',
    }), sniffer.device_info

    assert_equal ({
      type: :ios,
      version: '10.3.1',
      name: 'iOS',
    }), sniffer.os_info
  end

  it "Shopify POS on iPad is detected as tablet" do
    user_agent = "Shopify POS/3.10.12 (iPad; iOS 10.3.1; Scale/2.00)"
    sniffer = BrowserSniffer.new(user_agent)

    assert_equal :tablet, sniffer.form_factor
  end

  it "Shopify POS on iPad with modern user agent can be sniffed" do
    user_agent = "Shopify POS/iOS/3.12.1 (iPad4,7/com.jadedpixel.pos/10.3.1)"
    sniffer = BrowserSniffer.new(user_agent)

    assert_equal ({
      name: 'Shopify POS',
      version: '3.12.1',
    }), sniffer.browser_info

    assert_equal ({
      type: :tablet,
      model: '4,7',
    }), sniffer.device_info

    assert_equal ({
      type: :ios,
      version: '10.3.1',
      name: 'iOS',
    }), sniffer.os_info
  end

  it "Shopify POS Next on iPad with modern user agent can be sniffed" do
    user_agent = "Shopify POS Next/iOS/3.12.1 (iPad4,7/com.jadedpixel.pos/10.3.1)"
    sniffer = BrowserSniffer.new(user_agent)

    assert_equal ({
      name: 'Shopify POS',
      version: '3.12.1',
    }), sniffer.browser_info

    assert_equal ({
      type: :tablet,
      model: '4,7',
    }), sniffer.device_info

    assert_equal ({
      type: :ios,
      version: '10.3.1',
      name: 'iOS',
    }), sniffer.os_info
  end

  it "Shopify POS with okhttp user agent can be parsed" do
    user_agent = "okhttp/3.6.0"
    sniffer = BrowserSniffer.new(user_agent)

    assert_equal ({
      name: 'okhttp',
      version: '3.6.0',
    }), sniffer.browser_info
  end

  it "Shopify POS on Android can be sniffed (SmartWebView)" do
    user_agent = "com.jadedpixel.pos Shopify POS Dalvik/2.1.0 (Linux; U; Android 7.1.1; " \
    "SM-T560NU Build/NMF26X) POS - Debug 2.4.10 (1a5a407d00)/3405  Mozilla/5.0 " \
    "(Linux; Android 7.1.1; SM-T560NU Build/NMF26X; wv) AppleWebKit/537.36 " \
    "(KHTML, like Gecko) Version/4.0 Chrome/67.0.3396.87 Safari/537.36"
    sniffer = BrowserSniffer.new(user_agent)

    user_agent_with_suffix = "com.jadedpixel.pos Shopify POS Dalvik/2.1.0 (Linux; U; Android 7.1.1; " \
    "SM-T560NU Build/NMF26X) POS - Debug 2.4.10/1337 (1a5a407d00)/3405  Mozilla/5.0 " \
    "(Linux; Android 7.1.1; SM-T560NU Build/NMF26X; wv) AppleWebKit/537.36 " \
    "(KHTML, like Gecko) Version/4.0 Chrome/67.0.3396.87 Safari/537.36"
    sniffer_with_suffix = BrowserSniffer.new(user_agent_with_suffix)

    assert_equal ({
      name: 'Shopify POS',
      version: '2.4.10',
    }), sniffer.browser_info

    assert_equal ({
      type: :handheld,
      model: 'SM-T560NU',
    }), sniffer.device_info

    assert_equal ({
      type: :android,
      version: '7.1.1',
      name: 'Android',
    }), sniffer.os_info

    assert_equal sniffer.browser_info, sniffer_with_suffix.browser_info
    assert_equal sniffer.device_info, sniffer_with_suffix.device_info
    assert_equal sniffer.os_info, sniffer_with_suffix.os_info
  end

  it "Shopify POS on Android can be sniffed (Native App)" do
    user_agent = "Dalvik/2.1.0 (Linux; U; Android 7.1.1; SM-T560NU Build/NMF26X) " \
    "POS - Debug 2.4.10 (1a5a407d00)/3405"
    sniffer = BrowserSniffer.new(user_agent)

    user_agent_with_suffix = "Dalvik/2.1.0 (Linux; U; Android 7.1.1; SM-T560NU Build/NMF26X) " \
    "POS - Debug 2.4.10/1337 (1a5a407d00)/3405"
    sniffer_with_suffix = BrowserSniffer.new(user_agent_with_suffix)

    assert_equal ({
      name: 'Shopify POS',
      version: '2.4.10',
    }), sniffer.browser_info

    assert_equal ({
      type: :handheld,
      model: 'SM-T560NU',
    }), sniffer.device_info

    assert_equal ({
      type: :android,
      version: '7.1.1',
      name: 'Android',
    }), sniffer.os_info

    assert_equal sniffer.browser_info, sniffer_with_suffix.browser_info
    assert_equal sniffer.device_info, sniffer_with_suffix.device_info
    assert_equal sniffer.os_info, sniffer_with_suffix.os_info
  end

  it "Shopify Mobile in debug mode can be parsed" do
    user_agent = "Shopify Mobile/Android/6.0.0 (debug) (Build 1 with API 25 on Unknown Android SDK built for x86)"
    sniffer = BrowserSniffer.new(user_agent)

    assert_equal ({
      name: 'Shopify Mobile',
      version: '6.0.0 (debug)',
      build: '1',
      sdk_version: '25',
    }), sniffer.browser_info

    assert_equal ({
      type: :handheld,
      vendor: 'Unknown',
      model: 'Android SDK built for x86',
    }), sniffer.device_info

    assert_equal ({
      name: 'Android',
      type: :android,
    }), sniffer.os_info
  end

  it "Shopify Mobile in debug-push mode can be parsed" do
    user_agent = "Shopify Mobile/Android/6.0.0 (debug-push) (Build 1 with API 25 on Unknown Android SDK built for x86)"
    sniffer = BrowserSniffer.new(user_agent)

    assert_equal ({
      name: 'Shopify Mobile',
      version: '6.0.0 (debug-push)',
      build: '1',
      sdk_version: '25',
    }), sniffer.browser_info

    assert_equal ({
      type: :handheld,
      vendor: 'Unknown',
      model: 'Android SDK built for x86',
    }), sniffer.device_info

    assert_equal ({
      name: 'Android',
      type: :android,
    }), sniffer.os_info
  end

  it "ShopifyFoundation user agent can be parsed" do
    user_agent = "ShopifyFoundation"
    sniffer = BrowserSniffer.new(user_agent)

    assert_equal ({ name: 'ShopifyFoundation' }), sniffer.browser_info
    assert_predicate sniffer.device_info, :empty?
    assert_predicate sniffer.os_info, :empty?
  end

  it "old Shopify POS user agent can be parsed" do
    user_agent = "Dalvik/2.1.0 (Linux; U; Android 5.1; KUAIKABAO/R5100 Build/LMY47I) Shopify POS 0.9.4"
    sniffer = BrowserSniffer.new(user_agent)

    user_agent_with_suffix = "Dalvik/2.1.0 (Linux; U; Android 5.1; KUAIKABAO/R5100 Build/LMY47I) Shopify POS 0.9.4/7"
    sniffer_with_suffix = BrowserSniffer.new(user_agent_with_suffix)

    assert_equal ({
      name: 'Shopify POS',
      version: '0.9.4',
    }), sniffer.browser_info

    assert_equal ({
      type: :handheld,
    }), sniffer.device_info

    assert_equal ({
      name: 'Android',
      type: :android,
      version: '5.1',
    }), sniffer.os_info

    assert_equal sniffer.browser_info, sniffer_with_suffix.browser_info
    assert_equal sniffer.device_info, sniffer_with_suffix.device_info
    assert_equal sniffer.os_info, sniffer_with_suffix.os_info
  end

  it "Shopify Ping on iOS simulator can be sniffed" do
    user_agent = "Shopify Ping/iOS/1.0.0 (iPhone9,1 Simulator/com.shopify.ping/11.1.0)"
    sniffer = BrowserSniffer.new(user_agent)

    assert_equal ({
      name: 'Shopify Ping',
      version: '1.0.0',
    }), sniffer.browser_info

    assert_equal ({
      type: :handheld,
      model: '9,1',
    }), sniffer.device_info

    assert_equal ({
      type: :ios,
      version: '11.1.0',
      name: 'iOS',
    }), sniffer.os_info
  end

  it "Shopify Ping on iOS can be sniffed" do
    user_agent = "Shopify Ping/iOS/1.0.0 (iPhone9,1/com.jadedlabs.ping/11.1.0)"
    sniffer = BrowserSniffer.new(user_agent)

    assert_equal ({
      name: 'Shopify Ping',
      version: '1.0.0',
    }), sniffer.browser_info

    assert_equal ({
      type: :handheld,
      model: '9,1',
    }), sniffer.device_info

    assert_equal ({
      type: :ios,
      version: '11.1.0',
      name: 'iOS',
    }), sniffer.os_info
  end
end
