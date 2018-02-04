class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def handle_callback
    p request.headers['HTTP_SMARTSHEET_HOOK_CHALLENGE']
    challenge = params['challenge']

    response.headers['Smartsheet-Hook-Response'] = challenge
    DeliveryJob.perform_async()
    head 200, content_type: "text/html"
  end


end
