require 'net/https'
require 'uri'

class Location < ApplicationRecord
	validates :address, presence: true, uniqueness: true 
	
	def fetch_lat_and_lon
		uri = URI.parse("https://api.tomtom.com/search/2/geocode/539-27th-avenue-sf.json?key=9jFqlnjOFua3WGH7neAbCktFIatGIp6D")
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE

		request = Net::HTTP::Get.new(uri.request_uri)

		response = http.request(request)
		response.body

	end 
end
