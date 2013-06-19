# BrowserSniffer

## Description

Parses user agent strings and boils it all down to a few simple classifications.

## Installation

Add this line to your application's Gemfile:

    gem "browser_sniffer"

And then execute:

    $ bundle install

Or install it yourself as:

    $ git clone https://github.com/Shopify/browser_sniffer && cd browser_sniffer && bundle install && rake install

## Usage

```ruby
require "browser_sniffer"

client_info = BrowserSniffer.new(request.user_agent)
client_info.form_factor           # => :tablet
client_info.browser               # => :safari
client_info.engine                # => :webkit
client_info.major_browser_version # => 4
```

## Contributing

Fork, branch & pull request.

## Licenses

Based off [UAParser.js](https://github.com/faisalman/ua-parser-js)

Copyright (c) 2013 Shopify
Copyright (c) 2012-2013 Faisalman <fyzlman@gmail.com>
Dual licensed under GPLv2 & MIT
