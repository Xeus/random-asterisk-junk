require "rubygems"
#require "ruby-agi"
require "sinatra"

#agi = AGI.new

# Main route  - this is the form where we take the input
get '/gottatakethis' do
  # params[:yourname] will be replaced with the value entered for 
  # the input with name 'yourname'
  minutes = 2
  t = Time.now + (60 * minutes)
  # ("%m/%d/%Y %H:%M:%S") # 07/24/2006 09:09:03
  timeCallBack = t.strftime("%H-%M-%S-%m-%d-%Y")
  
  `/var/lib/asterisk/agi-bin/gencallfile.rb 19725107983 vt520-gtt s WaitTime=30 MaxRetries=1 #{timeCallBack}`

  body = "Sent."
  body
end
