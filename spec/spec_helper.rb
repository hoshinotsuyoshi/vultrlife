require 'coveralls'
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'vultrlife'
require 'rspec'
require 'pry'
require 'webmock/rspec'
