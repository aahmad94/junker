# @locations.each do |location|
#     json.set! location.id do 
#         json.extract! location, :lat, :lon
#         # json.partial! 'api/locations/location', location: location
#     end 
# end 
@locations.each_index do |idx|
    json.set! idx do 
        json.array! @locations[idx], "lat", "lon"
    end 
end 