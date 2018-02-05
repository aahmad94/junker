class DeliveryJob
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform()
    # do something
    mail = DeliveryMailer.reporting_email('passed in user string')
    p 'this is the speshul mail'
    p mail
    # result = ses_client.send_raw_email(mail)
    result = ses_client.send_raw_email({
      # source: "Address",
      # destinations: ["mzc2fd@virginia.edu"],
      raw_message: { # required
        data: mail.to_s, # required
      },
      # from_arn: "AmazonResourceName",
      # source_arn: "AmazonResourceName",
      # return_path_arn: "AmazonResourceName",
      tags: [
        {
          name: "MyTagName", # required
          value: "MyTagValue", # required
        },
      ],
      # configuration_set_name: "ConfigurationSetName",
    })
    p 'this is the speshul result'
    p result
  end

  def ses_client
    # @ses_client ||= begin
    #   AWS::SES::Base.new(
    #     access_key_id: Secrets.aws_ses_secrets[:aws_access_key_id],
    #     secret_access_key: Secrets.aws_ses_secrets[:aws_secret_access_key],
    #     proxy_server: Sq::Common.http_proxy
    #   ).tap do |client|
    #     client.connection.verify_mode = OpenSSL::SSL::VERIFY_PEER
    #   end
    # end
    @ses_client ||= Aws::SES::Client.new(region: 'us-east-1')
  end
end
