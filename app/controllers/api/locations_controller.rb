class Api::LocationsController < ApplicationController
  def index
    @locations = Location.all 
  end

  def create
    @location = Location.new({ lat: params[:lat], lon: params[:lon] })
    if @location.save 
      render :show
    else 
      render json: @location.errors.full_messages, status: 422
    end 
  end

  def update
    @location = Location.find(params[:id])
    if @location.update({is_trash: params[:is_trash]}) 
      render :show 
    else 
      render json: @location.errors.full_messages, status: 422
    end
  end 

  def route_coordinates
    truck_coord = [params[:lat], params[:lon]]
    bounds = calculate_bounds(truck_coord)
    @locations = Location.where("lat > ? AND lat < ? AND lon > ? AND lon < ?", bounds[:lat_min], bounds[:lat_max], bounds[:lon_min], bounds[:lon_max])
    render :index
  end

  private 
  	def calculate_bounds(coord = [50.97452, 5.86605])      

      uri = URI.parse("https://api.tomtom.com/routing/1/calculateReachableRange/#{coord[0]},#{coord[1]}/json?key=9jFqlnjOFua3WGH7neAbCktFIatGIp6D&fuelBudgetInLiters=0.33&constantSpeedConsumptionInLitersPerHundredkm=70,14")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(uri.request_uri)

      response = http.request(request)
      body = JSON.parse(response.body)
      boundaries = body["reachableRange"]["boundary"]
      bounds = Hash.new 
      lat = []
      lon = []
      boundaries.each do |coord| 
          lat.push(coord["latitude"])
          lon.push(coord["longitude"])
      end 
      bounds[:lat_min] = lat.min
      bounds[:lat_max] = lat.max 
      bounds[:lon_min] = lon.min 
      bounds[:lon_max] = lon.max 
      bounds
    end 

  # def fetch_lat_and_lon
  #   parsed_address = self.address.split(" ").join("%20")
    
  #   uri = URI.parse("https://api.tomtom.com/search/2/geocode/#{parsed_address}.json?key=9jFqlnjOFua3WGH7neAbCktFIatGIp6D")
  #   http = Net::HTTP.new(uri.host, uri.port)
  #   http.use_ssl = true
  #   http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  #   request = Net::HTTP::Get.new(uri.request_uri)

  #   response = http.request(request)
  #   body = JSON.parse(response.body)
  #   position = body["results"][0]["position"]

  #   self.lat = position["lat"]
  #   self.lon = position["lon"]
  #   self.save!
  # end 
end
