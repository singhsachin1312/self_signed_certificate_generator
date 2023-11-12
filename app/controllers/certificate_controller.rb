class CertificateController < ApplicationController

  def info
    cert = OpenSSL::X509::Certificate.new(File.read('server_cert.pem'))
    expiration_date = cert.not_after.strftime('%Y-%m-%d %H:%M:%S %Z')
    render json: { expiration_date: expiration_date }
  end
end
