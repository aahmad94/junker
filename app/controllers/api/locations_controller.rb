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
    # array of tuples with lat/lon info fir truck location
    truck_coords = params[:truck_coords] 

    # array of hashes with lat_min/lat_max/lon_min/lon_max bounds
    bounds = [] 
    truck_coords.each do |truck_coord| 
      bounds << calculate_bounds(truck_coord)
    end

    locations = []
    bounds.each_index do |bound|
      houses = Location.where("lat > ? AND lat < ? AND lon > ? AND lon < ?",
        bounds[bound][:lat_min], bounds[bound][:lat_max], bounds[bound][:lon_min], bounds[bound][:lon_max]).to_a
      
      truck_location = Location.new(lat: truck_coords[bound][0], lon: truck_coords[bound][1])
      locations << { truck: truck_location, houses: houses }
    end

    @locations = locations  
    render :json => @locations
  end

  private 
  	def calculate_bounds      
      uri = URI.parse("https://api.tomtom.com/routing/1/calculateReachableRange/#{coord[0]},#{coord[1]}/json?key=9jFqlnjOFua3WGH7neAbCktFIatGIp6D&fuelBudgetInLiters=0.6&constantSpeedConsumptionInLitersPerHundredkm=70,14")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(uri.request_uri)

      response = http.request(request)
      body = JSON.parse(response.body)
      boundaries = body["reachableRange"]["boundary"]

      # create min/max boundaries from array of all lat & lon values--this provides a square perimeter around a given location.
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
end
