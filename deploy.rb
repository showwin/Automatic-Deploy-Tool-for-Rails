require 'sinatra'
require 'json'

get '/' do
  "I'm working !!!"
end

post '/' do
  log_file = File.open('log.txt', 'a')
  json = JSON.parse(request.body.read)
  return if json['branch'] != 'master'
  begin
    deploy
    json['commits'].each do |commit|
      log_file.write("commit '" +
                     commit['message'] +
                     "' was deployed. @" +
                     Time.now.to_s)
    end
  rescue
    log_file.write('error! Master branch was not deployed successfully.')
  end
  log_file.close
end

def deploy
  path, pass = File.open('pathpass.txt', 'r')
                   .read.split(' ').map { |str| str.chomp }
  system("cd #{path} && git pull origin master")
  system("cd #{path} && rake assets:precompile RAILS_ENV=production")
  system("cd #{path} && rake db:migrate RAILS_ENV=production")
  system("echo '#{pass}' | sudo -S service httpd restart")
end
