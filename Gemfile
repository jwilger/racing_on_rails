# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby ">= 2.4.0"

gem "rails", "~> 5.2.1"

gem "activemerchant"
gem "activemodel-serializers-xml"
gem "acts_as_list"
gem "acts_as_tree", git: "https://github.com/amerine/acts_as_tree.git"
gem "Ascii85", require: "ascii85"
gem "authlogic", "< 4.4"
gem "axlsx", ">= 2.0.1"
gem "axlsx_rails", ">=0.5.2"
gem "bcrypt"
gem "bootsnap", ">= 1.1.0", require: false
gem "bootstrap-datepicker-rails"
gem "bootstrap-sass"
gem "capistrano"
gem "capistrano-bundler"
gem "carrierwave"
gem "chronic"
gem "ckeditor"
gem "coffee-rails"
gem "coffee-script-source"
gem "damerau-levenshtein"
gem "default_value_for"
gem "erubis"
gem "hashdiff"
gem "i18n"
gem "in_place_editing"
gem "jquery-rails"
gem "jquery-ui-rails"
gem "mini_magick"
gem "mysql2"
gem "newrelic_rpm"
gem "nokogiri"
gem "oj"
gem "paper_trail"
gem "parallel_tests"
gem "pdf-reader", require: "pdf/reader"
gem "prawn", git: "https://github.com/sandal/prawn.git"
gem "puma"
gem "rails-observers"
gem "rake"
gem "redcarpet"
gem "rest-client"
gem "ri_cal"
# Roo versions after 2.1.1 break fractional seconds in Excel import, and 2.1.1 has warnings in Ruby 2.4
gem "roo", git: "https://github.com/scottwillson/roo.git", branch: "v2.1.1-ruby-2-4"
gem "roo-xls"
gem "ruby-ole"
# Security update
gem "rubyzip"
gem "sass-rails"
gem "scrypt"
gem "spreadsheet"
gem "stripe"
gem "tabular"
gem "truncate_html"
gem "uglifier"
gem "will_paginate"
gem "will_paginate-bootstrap", git: "https://github.com/estately/will_paginate-bootstrap.git"
gem "yui-compressor"
gem "zip-zip"

# Require after WillPaginate
# version 6 doesn't work with our version of elasticsearch
gem "elasticsearch-model", "< 6.0.0"
gem "elasticsearch-rails", "< 6.0.0"

group :development do
  gem "brakeman"
  gem "bullet"
  gem "bundler-audit", github: "rubysec/bundler-audit"
  gem "capistrano-rails"
  gem "capistrano-rvm"
  gem "capistrano3-puma"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "rubocop", require: false
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :development, :test do
  gem "byebug", platforms: %i[mri mingw x64_mingw]
end

group :test do
  gem "capybara"
  gem "chromedriver-helper"
  gem "database_cleaner"
  gem "factory_bot_rails"
  gem "fakeweb", git: "https://github.com/chrisk/fakeweb.git"
  gem "minitest"
  gem "mocha", require: false
  gem "rails-controller-testing"
  gem "selenium-webdriver"
  gem "simplecov"
  gem "timecop"
end

group :staging, :production do
  gem "connection_pool"
  gem "dalli"
  gem "execjs"
  gem "libv8"
  gem "logstash-logger"
  gem "raygun4ruby"
  gem "therubyracer"
end
