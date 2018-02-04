require 'smartsheet'

access_token = '9rfszdyh1d9f9xba58i4ar1ef0'

# Id of sheet to load and update
sheet_id = '178667688093572'

# Configure logging
logger = Logger.new(STDOUT)
logger.level = Logger::INFO

# Initialize client SDK
client = Smartsheet::Client.new(token: access_token, logger: logger)

body = {
  to_bottom: true,
  cells: [
    {
      column_id: 7509120241690500,
      value: 'New New Route'
    },
    {
    	column_id: 1879620707477380,
    	value: '5660'
    },
    {
    	column_id: 6383220334847876,
    	value: '7'
    }
  ],
  locked: false
}

# Add rows to a sheet
response = client.sheets.rows.add(
  sheet_id: sheet_id,
  body: body
)
