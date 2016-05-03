class Api::LoginsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create
    body = JSON.parse(request.body.read)
    honeypot = Honeypot.find_or_create_by(ip: request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip)
    honeypot.increment!(:logins, 1)
    Login.create(body)
    LoginCount.inc(body['remote_addr'])
    render json: {status: :ok}, status: :ok
  end
end
