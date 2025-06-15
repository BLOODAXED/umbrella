# Write your solution below!
require "http"
require "json"
require "dotenv/load"

#setup keys
gmaps_key = ENV.fetch("GMAPS_KEY")
weather_key = ENV.fetch("PIRATE_WEATHER_KEY")

DEBUG = false

puts "Want to know it you need an umbrella?"
puts "Where are you located now?"
u_location = gets.chomp

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{u_location}&key=#{gmaps_key}"
gmaps_data = JSON.parse(HTTP.get(gmaps_url))
location = gmaps_data.dig("results",0,"geometry","location")
address = gmaps_data.dig("results",0,"formatted_address")
lat = location.fetch("lat")
lng = location.fetch("lng")


weather_url = "https://api.pirateweather.net/forecast/#{weather_key}/#{lat},#{lng}?exclude=minutely,exclude=alerts,exclude=daily"

weather_data = JSON.parse(HTTP.get(weather_url))
currently = weather_data.fetch("currently")
hourly = weather_data.fetch("hourly")
summary = hourly.fetch("summary")
current_temp = currently.fetch("temperature")
twelve_hours = hourly.fetch("data").first(12)

rain_message = "Extremely low chance of rain for the next 12 hours"
rain = false
hours_from_now = 0
iterator = 0

twelve_hours.each do |i|
  iterator = iterator+1
  rain_chance = i.fetch("precipProbability").to_f
  if DEBUG==true 
    puts rain_chance
  end
  if rain_chance > 0.10
    hours_from_now = iterator
    rain_message = "In #{iterator} hours, the chance of rain will be #{rain_chance}"
    rain = true
    break
  end
end

if DEBUG == true
  puts weather_url
end

#output data
puts
puts "Weather for #{address}"
puts "You're lat and long: #{lat.truncate(5)}, #{lng.truncate(5)}"
puts "Current Temperature: #{current_temp}"
puts "\n#{summary}"
puts 
puts rain_message

if rain == true
  puts "You might want to carry an umbrella!"
elsif
  puts "You probably won’t need an umbrella today."
end
