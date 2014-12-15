#!/usr/bin/env ruby

Dir.chdir(File.dirname(__FILE__))

basename = File.basename __FILE__

unless ARGV.size == 1
  files = (Dir["*.rb"] - [basename]).join(" | ")
  $stderr.puts "usage: #{basename} (#{files})"

  exit 1
end

# Run against source in local git repo
require 'bundler/setup'

require File.join('.', ARGV.first)
