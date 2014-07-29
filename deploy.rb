require 'sinatra'
require 'json'

post '/' do
	log_file = File.open("log.txt", "w")
	json = JSON.parse(request.body.read) 
	if json["ref"] == "refs/heads/master" 
		deploy
		json["commits"].each do |commit|
			log_file.write("commit '"+commit["message"]+"' was deployed. @"+Time.now.to_s)
		end
	else
		log_file.write("error")
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
