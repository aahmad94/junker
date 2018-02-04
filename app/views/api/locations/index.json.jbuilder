# @locations.each do |location|
#     json.set! location.id do 
#         json.extract! location, :lat, :lon
#         # json.partial! 'api/locations/location', location: location
#     end 
# end 
json.array! @locations, :lat, :lon