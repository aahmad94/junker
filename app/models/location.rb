require "json"
require 'net/https'
require 'uri'

class Location < ApplicationRecord
	# validates :address, presence: true, uniqueness: true 
	validates :lat, presence: true 
	validates :lon, presence: true 
	validates :is_trash, presence: true 

	# 	def fetch_lat_and_lon
	# 		parsed_address = self.address.split(" ").join("%20")
			
	# 		uri = URI.parse("https://api.tomtom.com/search/2/geocode/#{parsed_address}.json?key=9jFqlnjOFua3WGH7neAbCktFIatGIp6D")
	# 		http = Net::HTTP.new(uri.host, uri.port)
	# 		http.use_ssl = true
	# 		http.verify_mode = OpenSSL::SSL::VERIFY_NONE

	# 		request = Net::HTTP::Get.new(uri.request_uri)

	# 		response = http.request(request)
	# 		body = JSON.parse(response.body)
	# 		position = body["results"][0]["position"]

	# 		self.lat = position["lat"]
	# 		self.lon = position["lon"]
	# 		self.save!
	# end 
end
