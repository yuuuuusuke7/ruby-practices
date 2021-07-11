#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'pathname'
require '../lib/ls_command_execution'
require '../lib/ls_long_format'
require '../lib/ls_short_format'

opt = OptionParser.new

params = { long_format: false, reverse: false, dot_match: false }
opt.on('-l') { |v| params[:long_format] = v }
opt.on('-r') { |v| params[:reverse] = v }
opt.on('-a') { |v| params[:dot_match] = v }
opt.parse!(ARGV)
path = ARGV[0] || '.'
pathname = Pathname(path)

puts LsCommandExecution.new(pathname, **params).run_ls
