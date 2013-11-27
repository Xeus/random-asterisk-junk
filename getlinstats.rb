#!/usr/bin/ruby

# only works during the game as ESPN has different format otherwise

require 'net/http'
require 'rubygems'
require 'ruby-agi'		#for Asterisk AGI

agi = AGI.new

#source = Net::HTTP.get('espn.go.com', '/nba/player/_/id/4299/jeremy-lin')
#source = Net::HTTP.get('espn.go.com', '/nba/player/_/id/1703/carlos-boozer')
#source2 = source.dup

#match = source.match(/This Game<\/td><td style="text-align:right;">[0-9]+<\/td><td style="text-align:right;">[.0-9]+<\/td><td style="text-align:right;">[0-9]+<\/td><td style="text-align:right;">[0-9]+<\/td><td style="text-align:right;">[0-9]+<\/td><td style="text-align:right;">[0-9]+<\/td><td style="text-align:right;">[0-9]+<\/td><td style="text-align:right;">([0-9]+)/)[1].to_s
#match2 = source2.match(/This Game<\/td><td style="text-align:right;">[0-9]+<\/td><td style="text-align:right;">[.0-9]+<\/td><td style="text-align:right;">[0-9]+<\/td><td style="text-align:right;">([0-9]+)/)[1].to_s
match = 50
match2 = 102
agi.say_number(match)
agi.say_number(match2)