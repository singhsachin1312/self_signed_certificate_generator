# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

Ruby version - 3.0

Rails version - 7.0.4

* How to run the test suite - 
  First take the clone and run the ruby file on local system 
    command - ruby cert_generator.rb

  after this start the rails server with below command - 
    rails s -b 'ssl://localhost:3000?key=server_key.pem&cert=server_cert.pem'

  than run the rake task to check the expiration date of the server certificate .
    command - rake test
