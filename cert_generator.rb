# cert_generator.rb

require 'openssl'

def generate_ca
  key = OpenSSL::PKey::RSA.new(2048)
  ca = OpenSSL::X509::Certificate.new
  ca.version = 2
  ca.serial = 1
  ca.subject = OpenSSL::X509::Name.parse("/DC=org/DC=ruby-lang/CN=Ruby CA")
  ca.issuer = ca.subject
  ca.public_key = key.public_key
  ca.not_before = Time.now
  ca.not_after = ca.not_before + 365 * 24 * 60 * 60 # 1 year validity

  ef = OpenSSL::X509::ExtensionFactory.new
  ef.subject_certificate = ca
  ef.issuer_certificate = ca
  ca.add_extension(ef.create_extension("subjectKeyIdentifier", "hash", false))
  ca.add_extension(ef.create_extension("basicConstraints", "CA:TRUE", true))
  ca.add_extension(ef.create_extension("keyUsage", "keyCertSign, cRLSign", true))

  ca.sign(key, OpenSSL::Digest::SHA256.new)
  [key, ca]
end

def generate_certificate(ca_key, ca_cert, common_name)
  key = OpenSSL::PKey::RSA.new(2048)
  cert = OpenSSL::X509::Certificate.new
  cert.version = 2
  cert.serial = 2
  cert.subject = OpenSSL::X509::Name.parse("/DC=org/DC=ruby-lang/CN=#{common_name}")
  cert.issuer = ca_cert.subject
  cert.public_key = key.public_key
  cert.not_before = Time.now
  cert.not_after = cert.not_before + 365 * 24 * 60 * 60 # 1 year validity

  ef = OpenSSL::X509::ExtensionFactory.new
  ef.subject_certificate = cert
  ef.issuer_certificate = ca_cert
  cert.add_extension(ef.create_extension("subjectKeyIdentifier", "hash", false))
  cert.add_extension(ef.create_extension("keyUsage", "keyEncipherment", true))

  cert.sign(ca_key, OpenSSL::Digest::SHA256.new)
  [key, cert]
end

# Generate CA
ca_key, ca_cert = generate_ca

# Generate certificate
server_key, server_cert = generate_certificate(ca_key, ca_cert, "localhost")

# Save the certificates to files
File.write("ca_key.pem", ca_key.to_pem)
File.write("ca_cert.pem", ca_cert.to_pem)
File.write("server_key.pem", server_key.to_pem)
File.write("server_cert.pem", server_cert.to_pem)

puts "Certificates generated successfully."
