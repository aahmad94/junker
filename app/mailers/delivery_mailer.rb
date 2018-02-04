require 'smartsheet'

class DeliveryMailer < ApplicationMailer

  def reporting_email(user)
    mail_headers = {
      to: 'mzc2fd@virginia.edu',
      subject: 'Monthly Trash Pickup Report',
      from: 'mzc2fd@virginia.edu'
    }
    @user = user
    @url  = 'http://example.com/login'
    @trips = []
    @trips << Trip.new('8 miles', '2 hours 15 minutes')
    @trips << Trip.new('3 miles', '1 hour 10 minutes')
    @trips << Trip.new('8 miles', '2 hours 10 minutes')
    @trips << Trip.new('4 miles', '1 hour 30 minutes')
    @trips << Trip.new('1 mile', '40 minutes')
    @trips << Trip.new('5 miles', '1 hour 50 minutes')
    mail(mail_headers)
  end

  def gather_smartsheet()
    access_token = '9rfszdyh1d9f9xba58i4ar1ef0'
    sheet_id = '178667688093572'

    logger = Logger.new(STDOUT)
    logger.level = Logger::INFO

    client = Smartsheet::Client.new(token: access_token, logger: logger)


  end
end
