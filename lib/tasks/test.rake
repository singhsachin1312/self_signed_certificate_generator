desc 'Run the certificate expiration date verification'
task :test do
  sh 'ruby test_connection.rb'
end