class BrowserSniffer
  STRING_MAP = {
    :browser => {
      :oldsafari => {
        :major => {
          '/85' => '1',
          '/125' => '1',
          '/312' => '1',
          '/412' => '2',
          '/416' => '2',
          '/417' => '2',
          '/419' => '2'
        },
        :version => {
          '/85' => '1.0',
          '/125' => '1.2',
          '/312' => '1.3',
          '/412' => '2.0',
          '/416' => '2.0.2',
          '/417' => '2.0.3',
          '/419' => '2.0.4'
        }
      }
    },
    :os => {
      :windows => {
        :version => {
          '4.90' => 'ME',
          'NT3.51' => 'NT 3.11',
          'NT4.0' => 'NT 4.0',
          'NT 5.0' => '2000',
          'NT 5.1' => 'XP',
          'NT 5.2' => 'XP',
          'NT 6.0' => 'Vista',
          'NT 6.1' => '7',
          'NT 6.2' => '8',
          'NT 6.3' => '8.1',
          'NT 10.0' => '10',
          'ARM' => 'RT'
        }
      }
    }
  }

  REGEX_MAP = {
    :browser => [
      [
        # Shopify Mobile for iPhone or iPad
        %r{.*Shopify/\d+\s\((iPhone|iPad)\;\siOS\s[\d\.]+}i
      ], [[:name, 'Shopify Mobile']], [
        # Shopify Mobile for Android
        %r{.*Dalvik/[a-z0-9\.]+.*Shopify\s[\d+\.\/]+}i
      ], [[:name, 'Shopify Mobile']], [
        # Shopify POS for iOS
        %r{.*(Shopify\sPOS)\/([\d\.]+)\s\((iPhone|iPad|iPod\stouch)\;}i,
      ], [:name, :version], [
        # Old Shopify POS for Android
        %r{^Dalvik/[a-z0-9\.]+.*(Shopify\sPOS)\s(\d(?:\.\d+)*)(\/\d*)*}i,
      ], [:name, :version], [
        # Shopify POS for Android (Native App)
        %r{.*(\sPOS\s-).*\s([\d+\.]+)(\/\d*)*\s}i,
      ], [[:name, 'Shopify POS'], :version], [
        # Shopify POS for Android (SmartWebView)
        %r{.*(Shopify\sPOS)\s.*Android.*\s([\d+\.]+)(\/\d*)*\s}i,
      ], [:name, :version], [
        # Shopify POS uses this user agent
        %r{^(okhttp)\/([\d\.]+)}i
      ], [:name, :version], [
        # Shopify Mobile for iPhone or iPad
        %r{.*(Shopify Mobile)\/(?:iPhone\sOS|iOS)\/([\d\.]+) \((iPhone|iPad|iPod)}i
      ], [[:name, 'Shopify Mobile'], :version], [
        # Shopify POS Next for iPhone or iPad
        %r{.*(Shopify POS Next|Shopify POS)\/(?:iOS)\/([\d\.]+) \((iPhone|iPad|iPod)}i
      ], [[:name, 'Shopify POS'], :version], [
        # Shopify Mobile for Android
        %r{.*(Shopify Mobile)\/Android\/([\d\.]+(?: \(debug(?:|-push)\))?) \(Build (\d+) with API (\d+)}i
      ], [[:name, 'Shopify Mobile'], :version, :build, :sdk_version], [
        # ShopifyFoundation shared library
        /^(ShopifyFoundation)/i,
      ], [:name], [
        # Shopify Ping iOS
        %r{.*(Shopify Ping)\/(?:iPhone\sOS|iOS)\/([\d\.]+) \((iPhone|iPad|iPod)}i
      ], [[:name, 'Shopify Ping'], :version], [
        # Presto based
        /(opera\smini)\/((\d+)?[\w\.-]+)/i, # Opera Mini
        /(opera\s[mobiletab]+).+:version\/((\d+)?[\w\.-]+)/i, # Opera Mobi/Tablet
        /(opera).+:version\/((\d+)?[\w\.]+)/i, # Opera > 9.80
        /(opera)[\/\s]+((\d+)?[\w\.]+)/i # Opera < 9.80
      ], [:name, :version, :major, [:type, :opera]], [
        /\s(opr)\/((\d+)?[\w\.]+)/i # Opera Webkit
      ], [[:name, 'Opera'], :version, :major, [:type, :opera]], [
        # Mixed
        /(kindle)\/((\d+)?[\w\.]+)/i, # Kindle
        /(lunascape|maxthon|netfront|jasmine|blazer)[\/\s]?((\d+)?[\w\.]+)*/i, # Lunascape/Maxthon/Netfront/Jasmine/Blazer
        # Trident based
        /(avant\s|iemobile|slim|baidu)(?:browser)?[\/\s]?((\d+)?[\w\.]*)/i # Avant/IEMobile/SlimBrowser/Baidu
      ], [:name, :version, :major], [
        /(?:ms|\()(ie)\s((\d+)[\w\.]+)/i # Internet Explorer
      ], [:name, :version, :major, [:type, :ie]], [
        /Edge\/(\d+).\d+/i #Edge
      ], [:major, [:version, 10], [:name, 'Edge'], [:type, :edge]], [
        /Mozilla\/5.0.*Windows NT 6\.\d.*Trident\/7\.\d.*rv:(\d+)\.\d*/i #IE11 on Win7
      ], [:major, [:version, 7], [:name, 'Internet Explorer'], [:type, :ie]], [
        /Mozilla\/5.0.*Windows NT 10\.\d.*Trident\/7\.\d.*rv:(\d+)\.\d*.*like\sGecko/i #IE11 on Win10
      ], [:major, [:version, 10], [:name, 'Internet Explorer'], [:type, :ie]], [
        # Webkit/KHTML based
        /(rekonq)\/?((\d+)[\w\.]+)*/i, # Rekonq
        /(flock|rockmelt|midori|epiphany|silk|skyfire|ovibrowser|bolt)\/((\d+)?[\w\.-]+)/i # Chromium/Flock/RockMelt/Midori/Epiphany/Silk/Skyfire/Bolt
      ], [:name, :version, :major], [
        /(yabrowser)\/((\d+)?[\w\.]+)/i # Yandex
      ], [[:name, 'Yandex'], :version, :major], [
        /(comodo_dragon)\/((\d+)?[\w\.]+)/i # Comodo Dragon
      ], [[:name, 'Comodo Dragon'], :version, :major], [
        /(chromium)\/((\d+)?[\w\.-]+)/i, # Chromium
        /(chrome)\/v?((\d+)?[\w\.]+)/i # Chrome
      ], [:name, :version, :major, [:type, :chrome]], [
        /(omniweb|arora|[tizenoka]{5}\s?browser)\/v?((\d+)?[\w\.]+)/i # Chrome/OmniWeb/Arora/Tizen/Nokia
      ], [:name, :version, :major], [
        /(dolfin)\/((\d+)?[\w\.]+)/i # Dolphin
      ], [[:name, 'Dolphin'], :version, :major], [
        /((?:android.+)crmo|crios)\/((\d+)?[\w\.]+)/i # Chrome for Android/iOS
      ], [[:name, 'Chrome'], :version, :major, [:type, :chrome]], [
        /(FxiOS)\/((\d+)?[\w\.]+)/i # Firefox for iOS
      ], [[:name, 'Mobile Firefox'], :version, :major, [:type, :firefoxios]], [
        /version\/((\d+)?[\w\.]+).+?mobile\/\w+\s(safari)/i # Mobile Safari
      ], [:version, :major, [:name, 'Mobile Safari'], [:type, :safari]], [
        /Mozilla\/5.0 \((?:iPhone|iPad|iPod(?: Touch)?);(.*)AppleWebKit\/((\d+)?[\w\.]+).+?(mobile)\/\w?/i # ios webview
      ], [:version, :major, [:name, 'Mobile Safari'], [:type, :safari]], [
        /version\/((\d+)?[\w\.]+).+?(mobile\s?safari|safari)/i # Safari & Safari Mobile
      ], [:version, :major, :name, [:type, :safari]], [
        /webkit.+?(mobile\s?safari|safari)((\/[\w]+))/i # Safari < 3.0
      ], [:name, [:major, STRING_MAP[:browser][:oldsafari][:major]], [:version, STRING_MAP[:browser][:oldsafari][:version]], [:type, :safari]], [
        /(konqueror)\/((\d+)?[\w\.]+)/i, # Konqueror
        /(webkit|khtml)\/((\d+)?[\w\.]+)/i
      ], [:name, :version, :major], [
        # Gecko based
        /(navigator|netscape)\/((\d+)?[\w\.-]+)/i # Netscape
      ], [[:name, 'Netscape'], :version, :major], [
        /(swiftfox)/i, # Swiftfox
        /(iceweasel|camino|chimera|fennec|maemo\sbrowser|minimo|conkeror)[\/\s]?((\d+)?[\w\.\+]+)/i, # Iceweasel/Camino/Chimera/Fennec/Maemo/Minimo/Conkeror
        /(seamonkey|k-meleon|icecat|iceape|firebird|phoenix)\/((\d+)?[\w\.-]+)/i # Firefox/SeaMonkey/K-Meleon/IceCat/IceApe/Firebird/Phoenix
      ], [:name, :version, :major], [
        /(firefox)\/((\d+)?[\w\.-]+)/i, # Firefox
        /(mozilla)\/((\d+)?[\w\.]+).+rv\:.+gecko\/\d+/i, # Mozilla
      ], [:name, :version, :major, [:type, :firefox]], [
        # Other
        /(uc\s?browser|polaris|lynx|dillo|icab|doris|amaya|w3m|netsurf|word|excel)[\/\s]?((\d+)?[\w\.]+)/i, # UCBrowser/Polaris/Lynx/Dillo/iCab/Doris/Amaya/w3m/NetSurf/Word/Excel
        /(links)\s\(((\d+)?[\w\.]+)/i, # Links
        /(gobrowser)\/?((\d+)?[\w\.]+)*/i, # GoBrowser
        /(ice\s?browser)\/v?((\d+)?[\w\._]+)/i, # ICE Browser
        /(mosaic)[\/\s]((\d+)?[\w\.]+)/i # Mosaic
      ], [:name, :version, :major]
    ],
    :device => [
      [
        # Shopify Mobile for iPhone
        %r{.*Shopify Mobile/(?:iPhone\sOS|iOS)/[\d\.]+ \((iPhone)([\d,]+)}i
      ], [[:type, :handheld], :model], [
        # Shopify Mobile for iPad
        %r{.*Shopify Mobile/(?:iPhone\sOS|iOS)/[\d\.]+ \((iPad)([\d,]+)}i
      ], [[:type, :tablet], :model], [
        # Shopify Mobile for iPod touch
        %r{.*Shopify Mobile/(?:iPhone\sOS|iOS)/[\d\.]+ \((iPod)([\d,]+)}i
      ], [[:type, :handheld], :model], [
        # Shopify POS Next for iPhone
        %r{.*(?:Shopify POS Next|Shopify POS)/(?:iPhone\sOS|iOS)/[\d\.]+ \((iPhone)([\d,]+)}i
      ], [[:type, :handheld], :model], [
        # Shopify POS Next for iPad
        %r{.*(?:Shopify POS Next|Shopify POS)/(?:iPhone\sOS|iOS)/[\d\.]+ \((iPad)([\d,]+)}i
      ], [[:type, :tablet], :model], [
        # Shopify POS Next for iPod touch
        %r{.*(?:Shopify POS Next|Shopify POS)/(?:iPhone\sOS|iOS)/[\d\.]+ \((iPod)([\d,]+)}i
      ], [[:type, :handheld], :model], [
        # Shopify Ping for iPhone
        %r{.*Shopify Ping/(?:iPhone\sOS|iOS)/[\d\.]+ \((iPhone)([\d,]+)}i
      ], [[:type, :handheld], :model], [
        # Shopify Mobile for Android
        %r{.*Shopify Mobile\/(Android)\/[\d\.]+(?: \(debug(?:|-push)\))? \(Build \d+ with API \d+ on (.*?) ([^\)]*)\)}i
      ], [[:type, :handheld], :vendor, :model], [
        # Shopify POS for iPhone
        %r{.*Shopify POS\/[\d\.]+ \((iPhone)\;.*Scale/([\d\.]+)}i,
      ], [[:type, :handheld], :scale], [
        # Shopify POS for iPad
        %r{.*Shopify POS\/[\d\.]+ \((iPad)\;.*Scale/([\d\.]+)}i,
      ], [[:type, :tablet], :scale], [
        # Shopify POS for iPod touch
        %r{.*Shopify POS\/[\d\.]+ \((iPod touch)\;.*Scale/([\d\.]+)}i,
      ], [[:type, :handheld], :scale], [
        # Shopify POS for Android (SmartWebView)
        %r{.*Shopify\sPOS.*\(.*(Android)\s[\d\.]+\;\s(.*)\sBuild/.*\)\sPOS.*[\d+\.]+}i,
      ], [[:type, :handheld], :model], [
        # Shopify POS for Android (Native App)
        %r{.*\(.*(Android)\s[\d\.]+\;\s(.*)\sBuild/.*\)\sPOS.*[\d+\.]+}i,
      ], [[:type, :handheld], :model], [
        /\((playbook);[\w\s\);-]+(rim)/i # PlayBook
      ], [:model, :vendor, [:type, :tablet]], [
        /\((ipad);[\w\s\);-]+(apple)/i # iPad
      ], [:model, :vendor, [:name, :ipad], [:type, :tablet]], [
        /(hp).+(touchpad)/i, # HP TouchPad
        /(kindle)\/([\w\.]+)/i, # Kindle
        /\s(nook)[\w\s]+build\/(\w+)/i, # Nook
        /(dell)\s(strea[kpr\s\d]*[\dko])/i # Dell Streak
      ], [:vendor, :model, [:type, :tablet]], [
        /\((?:iphone|ipod(?: touch)?);.+(apple)/i # iPod Touch/iPhone
      ], [:model, :vendor, [:name, :iphone], [:type, :handheld]], [
        /(blackberry)[\s-]?(\w+)/i, # BlackBerry
        /(blackberry|benq|palm(?=\-)|sonyericsson|acer|asus|dell|huawei|meizu|motorola)[\s_-]?([\w-]+)*/i, # BenQ/Palm/Sony-Ericsson/Acer/Asus/Dell/Huawei/Meizu/Motorola
        /(hp)\s([\w\s]+\w)/i, # HP iPAQ
        /(asus)-?(\w+)/i # Asus
      ], [:vendor, :model, [:type, :handheld]], [
        /\((bb10);\s(\w+)/i # BlackBerry 10
      ], [[:vendor, 'BlackBerry'], :model, [:type, :handheld]], [
        /android.+((transfo[prime\s]{4,10}\s\w+|eeepc|slider\s\w+))/i # Asus Tablets
      ], [[:vendor, 'Asus'], :model, [:type, :tablet]], [
        /(sony)\s(tablet\s[ps])/i # Sony Tablets
      ], [:vendor, :model, [:type, :tablet]], [
        /(nintendo)\s([wids3u]+)/i # Nintendo
      ], [:vendor, :model, [:type, :console]], [
        /((playstation)\s[3portablevi]+)/i # Playstation
      ], [[:vendor, 'Sony'], :model, [:type, :console]], [
        /(sprint\s(\w+))/i # Sprint Phones
      ], [:vendor, :model, [:type, :handheld]], [
        /(htc)[;_\s-]+([\w\s_]+(?=\))|\w+)*/i, # HTC
        /(zte)-(\w+)*/i, # ZTE
        /(alcatel|geeksphone|huawei|lenovo|nexian|panasonic|(?=;\s)sony)[_\s-]?([\w-]+)*/i # Alcatel/GeeksPhone/Huawei/Lenovo/Nexian/Panasonic/Sony
      ], [:vendor, [:model, lambda {|str| str && str.gsub(/_/, ' ') }], [:type, :handheld]], [
        /\s((milestone|droid[2x]?))[globa\s]*\sbuild\//i, # Motorola
        /(mot)[\s-]?(\w+)*/i
      ], [[:vendor, 'Motorola'], :model, [:type, :handheld]], [
        /android.+\s((mz60\d|xoom[\s2]{0,2}))\sbuild\//i
      ], [[:vendor, 'Motorola'], :model, [:type, :tablet]], [
        /android.+((sch-i[89]0\d|shw-m380s|gt-p\d{4}|gt-n8000|sgh-t8[56]9))/i
      ], [[:vendor, 'Samsung'], :model, [:type, :tablet]], [
        # Samsung
        /((s[cgp]h-\w+|gt-\w+|galaxy\snexus))/i,
        /(sam[sung]*)[\s-]*(\w+-?[\w-]*)*/i,
        /sec-((sgh\w+))/i
      ], [[:vendor, 'Samsung'], :model, [:type, :handheld]], [
        /(sie)-(\w+)*/i # Siemens
      ], [[:vendor, 'Siemens'], :model, [:type, :handheld]], [
        /(maemo|nokia).*(n900|lumia\s\d+)/i, # Nokia
        /(nokia)[\s_-]?([\w-]+)*/i
      ], [[:vendor, 'Nokia'], :model, [:type, :handheld]], [
        /android\s3\.[-\s\w;]{10}((a\d{3}))/i # Acer
      ], [[:vendor, 'Acer'], :model, [:type, :tablet]], [
        /android\s3\.[-\s\w;]{10}(lg?)-([06cv9]{3,4})/i # LG
      ], [[:vendor, 'LG'], :model, [:type, :tablet]], [
        /((nexus\s4))/i,
        /(lg)[-e;\s\/]+(\w+)*/i
      ], [[:vendor, 'LG'], :model, [:type, :handheld]], [
        /opera\smobi/i,
        /android/i
      ], [[:type, :handheld]], [
        /nitro/i # Nintendo DS
      ], [[:type, :console]], [
        /(mobile|tablet);.+rv\:.+gecko\//i # Unidentifiable
      ], [:type, :vendor, :model]
    ],
    :engine => [
      [
        /(presto)\/((\d+)[\w\.]+)/i # Presto
      ], [:name, :version, :major, [:type, :presto]], [
        /(webkit)\/((\d+)[\w\.]+)/i # WebKit
      ], [:name, :version, :major, [:type, :webkit]], [
        /(trident)\/((\d+)[\w\.]+)/i # Trident
      ], [:name, :version, :major, [:type, :trident]], [
        /(netfront|netsurf|amaya|lynx|w3m)\/((\d+)[\w\.]+)/i, # NetFront/NetSurf/Amaya/Lynx/w3m
        /(khtml|tasman|links)[\/\s]\(?((\d+)[\w\.]+)/i, # KHTML/Tasman/Links
        /(icab)[\/\s]([23]\.(\d+)[\d\.]+)/i # iCab
      ], [:name, :version, :major], [
        /rv\:((\d+)[\w\.]+).*(gecko)/i # Gecko
      ], [:version, :major, :name, [:type, :gecko]]
    ],
    :os => [
      [
        # Shopify Mobile for iOS
        %r{.*Shopify/\d+\s\((?:iPhone|iPad)\;\s(iOS)\s([\d\.]+)}i
      ], [[:type, :ios], :version, [:name, 'iOS']], [
        # Shopify POS for iOS
        %r{.*Shopify\sPOS/[\d\.]+\s\((?:iPhone|iPad|iPod\stouch)\;\s(iOS)\s([\d\.]+)}i,
      ], [[:type, :ios], :version, [:name, 'iOS']], [
        # Old Shopify POS for Android
        /^Dalvik.*(Android)\s([\d\.]+)\;\s.*\s[\d+\.]+/i,
      ], [[:type, :android], :version, [:name, 'Android']], [
        # Shopify POS for Android
        /.*Shopify\sPOS\s.*(Android)\s([\d\.]+)\;\s.*\s[\d+\.]+\s/i,
      ], [[:type, :android], :version, [:name, 'Android']], [
        # Shopify Mobile for iOS
        %r{.*Shopify Mobile\/(iPhone\sOS|iOS)\/[\d\.]+ \(.*\/OperatingSystemVersion\((.*)\)}i
      ], [[:type, :ios], [:version, lambda { |str| str && str.scan(/\d+/).join(".") }], [:name, 'iOS']], [
        # Shopify Mobile for iPhone or iPad
        %r{.*(Shopify Mobile)\/(?:iPhone\sOS|iOS)[\/\d\.]* \((iPhone|iPad|iPod).*\/([\d\.]+)\)}i
      ], [[:type, :ios], [:name, 'iOS'], :version], [
        # Shopify POS Next for iPhone or iPad
        %r{.*(Shopify POS Next|Shopify POS)\/(?:iPhone\sOS|iOS)[\/\d\.]* \((iPhone|iPad|iPod).*\/([\d\.]+)\)}i
      ], [[:type, :ios], [:name, 'iOS'], :version], [
        # Shopify Ping for iOS
        %r{.*Shopify Ping\/(iOS)\/[\d\.]+ \(.*\/([\d\.]+)\)}i
      ], [[:type, :ios], :version, [:name, 'iOS']], [
        # Shopify Mobile for Android
        %r{.*Shopify Mobile\/(Android)\/[\d\.]+ }i
      ], [:name, [:type, :android]], [
        # Windows based
        /(windows)\snt\s6\.2;\s(arm)/i, # Windows RT
        /(windows\sphone(?:\sos)*|windows\smobile|windows)[\s\/]?([ntce\d\.\s]+\w)/i,
        /(microsoft windows)/i
      ], [:name, [:version, STRING_MAP[:os][:windows][:version]], [:type, :windows]], [
        /(win(?=3|9|n)|win\s9x\s)([nt\d\.]+)/i
      ], [[:name, 'Windows'], [:version, STRING_MAP[:os][:windows][:version]], [:type, :windows]], [
        # Mobile/Embedded OS
        /\((bb)(10);/i # BlackBerry 10
      ], [[:name, 'BlackBerry'], :version, [:type, :blackberry]], [
        /(blackberry)\w*\/?([\w\.]+)*/i, # Blackberry
        /(rim\stablet\sos)[\/\s-]?([\w\.]+)*/i # RIM
      ], [:name, :version, [:type, :blackberry]], [
        /(android)[\/\s-]?([\w\.]+)*/i # Android
      ], [:name, :version, [:type, :android]], [
        /(tizen)\/([\w\.]+)/i, # Tizen
        /(webos|palm\os|qnx|bada|meego)[\/\s-]?([\w\.]+)*/i # WebOS/Palm/QNX/Bada/MeeGo
      ], [:name, :version], [
        /(symbian\s?os|symbos|s60(?=;))[\/\s-]?([\w\.]+)*/i # Symbian
      ], [[:name, 'Symbian'], :version],[
        /mozilla.+\(mobile;.+gecko.+firefox/i # Firefox OS
      ], [[:name, 'Firefox OS'], :version], [
        # Console
        /(nintendo|playstation)\s([wids3portablevu]+)/i, # Nintendo/Playstation
      ], [:name, :version], [
        # GNU/Linux based
        /(mint)[\/\s\(]?(\w+)*/i, # Mint
        /(joli|[kxln]?ubuntu|debian|[open]*suse|gentoo|arch|slackware|fedora|mandriva|centos|pclinuxos|redhat|zenwalk)[\/\s-]?([\w\.-]+)*/i, # Joli/Ubuntu/Debian/SUSE/Gentoo/Arch/Slackware/Fedora/Mandriva/CentOS/PCLinuxOS/RedHat/Zenwalk
        /(hurd|linux)\s?([\w\.]+)*/i, # Hurd/Linux
        /(gnu)\s?([\w\.]+)*/i # GNU
      ], [:name, :version, [:type, :linux]], [
        /(cros)\s[\w]+\s([\w\.]+\w)/i # Chromium OS
      ], [[:name, 'Chromium OS'], :version],[
        # Solaris
        /(sunos)\s?([\w\.]+\d)*/i # Solaris
      ], [[:name, 'Solaris'], :version], [
        # BSD based
        /\s([frentopc-]{0,4}bsd|dragonfly)\s?([\w\.]+)*/i # FreeBSD/NetBSD/OpenBSD/PC-BSD/DragonFly
      ], [:name, :version],[
        /(ip[honead]+)(?:.*os\s*([\w]+)*\slike\smac|;\sopera)/i # iOS
      ], [[:name, 'iOS'], [:version, lambda {|str| str && str.gsub(/_/, '.') }], [:type, :ios]], [
        /(mac\sos\sx)\s?([\w\s\.]+\w)*/i # Mac OS
      ], [:name, [:version, lambda {|str| str && str.gsub(/_/, '.') }], [:type, :mac]], [
        # Other
        /(haiku)\s(\w+)/i, # Haiku
        /(aix)\s((\d)(?=\.|\)|\s)[\w\.]*)*/i, # AIX
        /(macintosh|mac(?=_powerpc)|plan\s9|minix|beos|os\/2|amigaos|morphos|risc\sos)/i, # Plan9/Minix/BeOS/OS2/AmigaOS/MorphOS/RISCOS
        /(unix)\s?([\w\.]+)*/i # UNIX
      ], [:name, :version]
    ]
  }
end
