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
        # Shopify POS Go
        /WSC6X|WTH11/i
      ], [[:name, 'Shopify POS Go']],[
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
        # Shopify POS for Android (React Native App)
        %r{(Shopify POS)\/([\d\.]+)[^\/]*\/(Android)\/(\d+)}i,
      ], [[:name, 'Shopify POS'], :version], [
        # Shopify POS for iOS (React Native App)
        %r{(Shopify POS)\/([\d\.]+)[^\/]*\/(iOS)\/([\d\.]+)}i,
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
        %r{.*(Shopify Mobile)\/Android\/([\d\.]+)(?: \((debug(?:|-push))\))? \(Build (\d+) with API (\d+)}i
      ], [[:name, 'Shopify Mobile'], :version, :debug_mode, :build, :sdk_version], [
        # ShopifyFoundation shared library
        /^(ShopifyFoundation)/i,
      ], [:name], [
        # Shopify Ping iOS
        %r{.*(Shopify Ping)\/(?:iPhone\sOS|iOS)\/([\d\.]+) \((iPhone|iPad|iPod)}i
      ], [[:name, 'Shopify Ping'], :version], [
        # Shopify CLI
        %r{.*(Shopify CLI)(?:; v=([\d\.]+))?}i 
      ], [[:name, 'Shopify CLI'], :version], [
        # Presto based
        /(opera\smini)\/((\d+)?[\w\.-]+)/i, # Opera Mini
        /(opera\s(mobile|tab)).+:version\/((\d+)?[\w\.-]+)/i, # Opera Mobi/Tablet
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
        /Mozilla\/5.0.*Windows NT 6\.\d.*Trident\/7\.\d.*rv:(\d+)\.\d*/i #IE11 on Win7
      ], [:major, [:version, 7], [:name, 'Internet Explorer'], [:type, :ie]], [
        /Mozilla\/5.0.*Windows NT 10\.\d.*Trident\/7\.\d.*rv:(\d+)\.\d*.*like\sGecko/i #IE11 on Win10
      ], [:major, [:version, 10], [:name, 'Internet Explorer'], [:type, :ie]], [
        # Webkit/KHTML based
        /(rekonq)\/?((\d+)[\w\.]+)*/i, # Rekonq
        /(flock|rockmelt|midori|epiphany|silk|skyfire|ovibrowser|bolt)\/((\d+)?[\w\.-]+)/i # Chromium/Flock/RockMelt/Midori/Epiphany/Silk/Skyfire/Bolt
      ], [:name, :version, :major], [
        /(yabrowser)\/((\d+)?[\w\.]+)/i # Yandex Browser
      ], [[:name, 'Yandex Browser'], :version, :major, [:type, :yandex]], [
        /(comodo_dragon)\/((\d+)?[\w\.]+)/i # Comodo Dragon
      ], [[:name, 'Comodo Dragon'], :version, :major], [
        /(vivaldi)\/((\d+)?[\w\.]+)/i # Vivaldi
      ], [[:name, 'Vivaldi'], :version, :major, [:type, :vivaldi]], [
        /(brave)\/((\d+)?[\w\.]+)/i # Brave
      ], [[:name, 'Brave'], :version, :major, [:type, :brave]], [
        /(?:Edge|Edg)\/(\d+).\d+/i # Edge (must come before Chrome patterns)
      ], [:major, [:version, 10], [:name, 'Edge'], [:type, :edge]], [
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
        /(ice\s?browser)\/v?((\d+)?[\w\.]+)/i, # ICE Browser
        /(mosaic)[\/\s]((\d+)?[\w\.]+)/i # Mosaic
      ], [:name, :version, :major]
    ],
    :in_app_browser => [
      [
        /FBAN\/FBIOS/,
        /FB_IAB\/FB4A/,
        /FBAN\/MessengerForiOS/,
        /FB_IAB\/MESSENGER/,
      ], [[:type, :facebook]], [
        /Instagram/,
      ], [[:type, :instagram]],
    ],
    :device => [
      [
        # Shopify POS Go
        /WSC6X|WTH11/i
      ], [[:type, :handheld], [:name, 'Shopify POS Go']],[
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
        # Shopify POS for iOS iPhone/iPod (React Native App)
        %r{.*Shopify POS\/[\d\.]+[^\/]*\/(iOS)\/[\d\.]+\/Apple\/((iPhone|iPod)[^\/]*)\/}i,
      ], [[:type, :handheld], :model], [
        # Shopify POS for iOS iPad (React Native App)
        %r{.*Shopify POS\/[\d\.]+[^\/]*\/(iOS)\/[\d\.]+\/Apple\/(iPad[^\/]*)\/}i,
      ], [[:type, :tablet], :model], [
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
        # New tablet patterns (must come early to avoid generic matches)
        # Xiaomi Tablets
        /android.+;\s((?:redmi\s+pad|(?:redmi\s*)?mi[\s\-]*pad)[^;]*?)\s*build/i,
        # Xiaomi tablet numeric codes (pad models like 24091RPADG)
        /android.+;\s(\d{5}RPAD[A-Z])\s*build/i
      ], [:model, [:vendor, 'Xiaomi'], [:type, :tablet]], [
        # Huawei Tablets
        /android.+;\s(mediapad[^;]*?)\s*build/i,
        /android.+;\s((?:ag[rs][2356]?k?|bah[234]?|bg[2o]|bt[kv]|cmr|cpn|db[ry]2?|jdn2|got|kob2?k?|mon|pce|scm|sht?|[tw]gr|vrd)-[ad]?[lw][0125][09]b?)\s*build/i
      ], [:model, [:vendor, 'Huawei'], [:type, :tablet]], [
        # Honor Tablets
        /android.+;\s((?:brt|eln|hey2?|gdi|jdn)-[^\s;]*)\s*build/i
      ], [:model, [:vendor, 'Honor'], [:type, :tablet]], [
        # OPPO Tablets
        /android.+;\s(opd2\d{3}a?)\s*build/i
      ], [:model, [:vendor, 'OPPO'], [:type, :tablet]], [
        # Huawei Mobile (must come before generic patterns) 
        /android.+;\s((?:hbp|alm|ane|art|ata|bla|col|cro|dub|ele|emm|eva|hma|hry|lya|mar|nce|pot|sne|vce|vne|yal)-[lx][0-9x]+)\s+build/i
      ], [:model, [:vendor, 'Huawei'], [:type, :handheld]], [
        # Lenovo tablets
        /android.+;\s(let\d+[^;]*?)\s*build/i
      ], [:model, [:vendor, 'Lenovo'], [:type, :tablet]], [
        # Onyx e-reader devices
        /android.+;\s(note(?:air|pro)[^;]*?)\s*build/i
      ], [:model, [:vendor, 'Onyx'], [:type, :tablet]], [
        # New mobile patterns (after tablets but before generic patterns)
        # Xiaomi Mobile
        /android.+;\s(poco[^;]*?)\s*build/i,
        /android.+;\s((?:redmi[^;]*?|mi[\s\d][^;]*?))\s*build/i,
        # Xiaomi numeric model codes (like 24091RPADG)
        /android.+;\s(\d{5}[a-z]+[^;]*?)\s*build/i
      ], [:model, [:vendor, 'Xiaomi'], [:type, :handheld]], [
        # OnePlus Mobile
        /android.+;\s(oneplus[^;]*?)\s*build/i
      ], [:model, [:vendor, 'OnePlus'], [:type, :handheld]], [
        # Realme Mobile
        /android.+;\s(realme[^;]*?)\s*build/i
      ], [:model, [:vendor, 'Realme'], [:type, :handheld]], [
        # Vivo Mobile
        /android.+;\s(vivo[^;]*?)\s*build/i
      ], [:model, [:vendor, 'Vivo'], [:type, :handheld]], [
        # OPPO Mobile
        /android.+;\s(oppo[^;]*?)\s*build/i
      ], [:model, [:vendor, 'OPPO'], [:type, :handheld]], [
        # Google Pixel devices
        /android.+;\s(pixel[\w\s]*pro[^;]*?)\s+build/i,
        /android.+;\s(pixel[\w\s]*[^;]*?)\s+build/i
      ], [:model, [:vendor, 'Google'], [:type, :handheld]], [
        /\((playbook);[\w\s\);-]+(rim)/i # PlayBook
      ], [:model, :vendor, [:type, :tablet]], [
        # iPad with modern device identifier format (iPad15,x iPad16,x etc)
        /\((ipad\d+,\d+);[^)]*\)/i
      ], [[:model, 'iPad'], [:vendor, 'Apple'], [:name, :ipad], [:type, :tablet]], [
        /\((ipad);[\w\s\);-]+(apple)/i # iPad
      ], [:model, :vendor, [:name, :ipad], [:type, :tablet]], [
        /(hp).+(touchpad)/i, # HP TouchPad
        /(kindle)\/([\w\.]+)/i, # Kindle
        /\s(nook)[\w\s]+build\/(\w+)/i, # Nook
        /(dell)\s(strea[kpr\s\d]*[\dko])/i # Dell Streak
      ], [:vendor, :model, [:type, :tablet]], [
        # iPhone with modern device identifier format (iPhone17,x etc)
        /\((iphone\d+,\d+);[^)]*\)/i
      ], [[:model, 'iPhone'], [:vendor, 'Apple'], [:name, :iphone], [:type, :handheld]], [
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
        /(nintendo)\s+(switch|wii\s*u?|3?ds)/i # Nintendo (improved model parsing)
      ], [:vendor, :model, [:type, :console]], [
        # PlayStation Vita
        /(playstation vita)\s+[\d\.]+/i
      ], [[:model, 'PlayStation Vita'], [:vendor, 'Sony'], [:type, :console]], [
        /((playstation)\s[3portablevi]+)/i # Playstation (generic)
      ], [[:vendor, 'Sony'], :model, [:type, :console]], [
        # PlayStation 4
        /(playstation 4)\s+[\d\.]+/i
      ], [[:model, 'PlayStation 4'], [:vendor, 'Sony'], [:type, :console]], [
        # PlayStation 5  
        /playstation;\s+(playstation 5)\/[\d\.]+/i
      ], [[:model, 'PlayStation 5'], [:vendor, 'Sony'], [:type, :console]], [
        # Xbox Series X/S (Windows-based)
        /windows nt .+;\s+xbox;\s+(xbox series [xs])/i
      ], [[:model, 'Xbox Series X'], [:vendor, 'Microsoft'], [:type, :console]], [
        # Xbox One (Windows-based)
        /windows nt .+;\s+xbox_one_ed/i
      ], [[:model, 'Xbox One'], [:vendor, 'Microsoft'], [:type, :console]], [
        # Xbox One (Windows Phone-based)
        /windows phone .+;\s+xbox;\s+(xbox one)/i
      ], [:model, [:vendor, 'Microsoft'], [:type, :console]], [
        # Xbox Series X/S (legacy format)
        /\(xbox;\s+(xbox series [xs])\)/i
      ], [:model, [:vendor, 'Microsoft'], [:type, :console]], [
        # Xbox One (legacy format)
        /\(xbox;\s+(xbox one)\)/i
      ], [:model, [:vendor, 'Microsoft'], [:type, :console]], [
        /(sprint\s(\w+))/i # Sprint Phones
      ], [:vendor, :model, [:type, :handheld]], [
        /(htc)[;_\s-]+([\w\s]+(?=\))|\w+)*/i, # HTC
        /(zte)-(\w+)*/i, # ZTE
        /(alcatel|geeksphone|huawei|lenovo|nexian|panasonic|(?=;\s)sony)[_\s-]?([\w-]+)*/i # Alcatel/GeeksPhone/Huawei/Lenovo/Nexian/Panasonic/Sony
      ], [:vendor, [:model, lambda {|str| str && str.gsub(/_/, ' ') }], [:type, :handheld]], [
        # Modern Motorola devices (must come before generic Motorola pattern)
        /android.+;\s(moto\s+[^;]*?)\s*build/i
      ], [:model, [:vendor, 'Motorola'], [:type, :handheld]], [
        /\s((milestone|droid[2x]?))[globa\s]*\sbuild\//i, # Motorola
        /(mot)[\s-]?(\w+)*/i
      ], [[:vendor, 'Motorola'], :model, [:type, :handheld]], [
        /android.+\s((mz60\d|xoom[\s2]{0,2}))\sbuild\//i
      ], [[:vendor, 'Motorola'], :model, [:type, :tablet]], [
        /android.+((sch-i[89]0\d|shw-m380s|sm-[ptx]\w{2,4}|gt-[pn]\d{2,4}|sgh-t8[56]9|nexus 10))/i
      ], [[:vendor, 'Samsung'], :model, [:type, :tablet]], [
        # Samsung
        /android.+;\s(sm-s[^;)\s]*)/i, # Samsung Galaxy S-series phones  
        /((s[cgp]h-\w+|gt-\w+|galaxy\snexus))/i,
        /(sam[sung]*)[\s-]*(\w+-?[\w-]*)*/i,
        /sec-((sgh\w+))/i
      ], [:model, [:vendor, 'Samsung'], [:type, :handheld]], [
        /(sie)-(\w+)*/i # Siemens
      ], [[:vendor, 'Siemens'], :model, [:type, :handheld]], [
        /(maemo|nokia).*(n900|lumia\s\d+)/i, # Nokia
        /(nokia)[\s_-]?([\w-]+)*/i
      ], [[:vendor, 'Nokia'], :model, [:type, :handheld]], [
        /android\s3\.[-\s\w;]{10}((a\d{3}))/i # Acer
      ], [[:vendor, 'Acer'], :model, [:type, :tablet]], [
        /android\s3\.[-\s\w;]{10}(lg?)-([06cv9]{3,4})/i # LG
      ], [[:vendor, 'LG'], :model, [:type, :tablet]], [
        # Xiaomi Tablets (must come before generic mobile patterns)
        /android.+;\s((?:red)?mi[\s\-]*pad[\w\s]*)\sbuild/i
      ], [[:vendor, 'Xiaomi'], :model, [:type, :tablet]], [
        # Huawei Tablets (must come before generic mobile patterns)
        /android.+;\s(mediapad[\w\s]*)\sbuild/i,
        /android.+;\s((?:ag[rs][2356]?k?|bah[234]?|bg[2o]|bt[kv]|cmr|cpn|db[ry]2?|jdn2|got|kob2?k?|mon|pce|scm|sht?|[tw]gr|vrd)-[ad]?[lw][0125][09]b?)\sbuild/i
      ], [[:vendor, 'Huawei'], :model, [:type, :tablet]], [
        # Honor Tablets (must come before generic mobile patterns)
        /android.+;\s((?:brt|eln|hey2?|gdi|jdn)-a?[lnw]09|(?:ag[rm]3?|jdn2|kob2)-a?[lw]0[09]hn)\sbuild/i
      ], [[:vendor, 'Honor'], :model, [:type, :tablet]], [
        # OPPO Tablets (must come before generic mobile patterns)
        /android.+;\s(opd2\d{3}a?)\sbuild/i
      ], [[:vendor, 'OPPO'], :model, [:type, :tablet]], [
        /((nexus\s4))/i,
        /(lg)[-e;\s\/]+(\w+)*/i
      ], [[:vendor, 'LG'], :model, [:type, :handheld]], [
        # Amazon Fire TV
        /android.+;\s(aft[a-z0-9]+)(?:\s+build|\))/i
      ], [:model, [:vendor, 'Amazon'], [:type, :console]], [
        # Amazon Fire tablets  
        /android.+;\s(kf[a-z]+[^;]*?)\s*build/i
      ], [:model, [:vendor, 'Amazon'], [:type, :tablet]], [
        # Apple TV
        /appletv(\d+,\d+)\/([\d\.]+)/i  
      ], [[:model, 'Apple TV'], [:vendor, 'Apple'], [:type, :console]], [
        # Chromecast
        /crkey\s+([^)]+)/i
      ], [[:model, 'Chromecast'], [:vendor, 'Google'], [:type, :console]], [
        # Google ADT (Android TV Developer)
        /android.+;\s(adt-\d+)\s+build/i
      ], [:model, [:vendor, 'Google'], [:type, :console]], [
        # Roku devices
        /roku(\w+)\/([^(]+)/i
      ], [:model, [:vendor, 'Roku'], [:type, :console]], [
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
        # Shopify Retail OS on POS Go
        /WSC6X|WTH11/i
      ], [[:name, 'Shopify Retail OS']],[
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
        # Shopify Mobile for iPhone or iPad with build number
        %r{.*(Shopify Mobile)\/(?:iPhone\sOS|iOS)[\/\d\.]* \((iPhone|iPad|iPod).*\/([\d\.]+) - Build [\d]*\)}i
      ], [[:type, :ios], [:name, 'iOS'], :version], [
        # Shopify POS Next for iPhone or iPad
        %r{.*(Shopify POS Next|Shopify POS)\/(?:iPhone\sOS|iOS)[\/\d\.]* \((iPhone|iPad|iPod).*\/([\d\.]+)\)}i
      ], [[:type, :ios], [:name, 'iOS'], :version], [
        # Shopify POS for iOS (React Native App)
        %r{.*Shopify POS\/[\d\.]+[^\/]*\/(iOS)\/([\d\.]+)\/(Apple)\/(iPhone|iPad|iPod)[^\/]*\/}i
      ], [[:type, :ios], :version, [:name, 'iOS']], [
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
      ], [[:name, 'Chromium OS'], :version, [:type, :chromium_os]],[
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
