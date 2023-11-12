require 'net/http'
require 'json'
require 'openssl'

def verify_certificate_expiration
  uri = URI.parse('https://localhost:3000/certificate_info')

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  http.ca_file = ('ca_cert.pem').to_s

  request = Net::HTTP::Get.new(uri.request_uri)

  response = http.request(request)

  if response.code.to_i == 200
    result = JSON.parse(response.body)
    expiration_date = result['expiration_date']
    puts "Server certificate expires on: #{expiration_date}"
  else
    puts "Failed to retrieve certificate information. HTTP Status: #{response.code}"
  end
end

# Verify certificate expiration
verify_certificate_expiration
