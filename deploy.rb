require 'sinatra'
require 'json'

post '/' do
  log_file = File.open("log.txt", "a")
  log_file.write("\n")
	log_file.write(Time.now.to_s+"\n")
	log_file.write("received post request.\n")
	json = JSON.parse(request.body.read)
	return unless json["name"] == "showwin" && json["branch"] == "production"
  begin
    deploy
    log_file.write("successfully deployed.\n")
  rescue
    log_file.write("error! Master branch was not deployed successfully.\n")
  end
  log_file.close
end

def deploy
  path, pass = File.open("pathpass.txt", "r").read.split(" ").map{|str| str.chomp}
  system("cd #{path} && git pull origin master")
  system("cd #{path} && rake assets:precompile RAILS_ENV=production")
  system("cd #{path} && rake db:migrate RAILS_ENV=production")
  system("echo '#{pass}' | sudo -S service httpd restart")
end
