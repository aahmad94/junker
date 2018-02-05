require 'smartsheet'

# Find cell in a row, based on column name
def get_cell_by_column_name(row, column_name, column_map)
  column_id = column_map[column_name]
  row[:cells].find {|cell| cell[:column_id] == column_id}
end

# Evaluate row contents, and build update info if needed
def evaluate_row_and_build_update(row, column_map)
  status_cell = get_cell_by_column_name(row, 'Status', column_map)
  remaining_cell = get_cell_by_column_name(row, 'Remaining', column_map)

  row_to_update = nil

  # Check if status is complete but remaining is not 0
  if status_cell[:display_value] == 'Complete' && remaining_cell[:display_value] != '0'
    puts "Updating row #{row[:row_number]}"
    row_to_update = {
      id: row[:id],
      cells: [{
        columnId: remaining_cell[:column_id],
        value: 0
      }]
    }
  end
  return row_to_update
end

# If empty, defaults to environment variable SMARTSHEET_ACCESS_TOKEN
access_token = '9rfszdyh1d9f9xba58i4ar1ef0'

# Id of sheet to load and update
sheet_id = '178667688093572'

# Configure logging
logger = Logger.new(STDOUT)
logger.level = Logger::INFO

# Initialize client SDK
client = Smartsheet::Client.new(token: access_token, logger: logger)

begin
  # Load entire sheet
  sheet = client.sheets.get(sheet_id: sheet_id)
  puts "Loaded #{sheet[:total_row_count]} rows from sheet '#{sheet[:name]}'"

  # Build column map for later reference - converts column name to column id
  column_map = {}
  sheet[:columns].each do |column|
    column_map[column[:title]] = column[:id]
  end

  # Accumulate rows needing update here
  rows_to_update = []

  # Evaluate each row
  sheet[:rows].each do |row|
    update_row = evaluate_row_and_build_update(row, column_map)
    rows_to_update.push(update_row) unless update_row.nil?
  end

  if rows_to_update.empty?
    puts 'No Update Required'
  else
    # Save changes to sheet
    client.sheets.rows.update(sheet_id: sheet[:id], body: rows_to_update)
  end

rescue Smartsheet::ApiError => e
  puts 'API returned error:'
  puts "\t error code: #{e.error_code}"
  puts "\t message: #{e.message}"
  puts "\t ref id: #{e.ref_id}"
end
