Automatic-Deploy-Tool-for-Rails
=============
This is a Sinatra app to automatically deploy Rails-app via GitHub Webhooks.

## Workflow
1. `git push origin master` on your local.
2. Use [GitHub Webhooks](https://developer.github.com/webhooks) to send a POST request to your server.
3. **This tool** receives the request and execute following commands: (if commits are to master branch)
  * `git pull origin master`
  * `rake assets:precompile RAILS_ENV=production`
  * `rake db:migrate RAILS_ENV=production`
  * `sudo service httpd restart`

## Environment
Apache + Passenger

## How to Use
Example URLs   
Rails App: http://example.com  
This tool: http://deploy.example.com  

`/etc/httpd/conf/httpd.conf`
```
<virtualhost *:80>
 servername example.com
 serveralias www.example.com
 documentroot /var/www/example/public
 railsbaseuri /
 <directory /var/www/example/public>
   allowoverride all
   order allow,deny
   allow from all
   options -multiviews
 </directory>
</virtualhost>
 
<virtualhost *:80>
 servername deploy.example.com
 serveralias deploy.example.com
 documentroot /var/www/deploy/public
 RackEnv production
 <directory /var/www/deploy/public> 
   allowoverride all
   order allow,deny
   allow from all
   options -multiviews
 </directory>
</virtualhost>
```

And, put this tool at `/var/www/deploy`

```
$ cd /var/www/
$ git clone https://github.com/showwin/Automatic-Deploy-Tool-for-Rails.git
$ mv Automatic-Deploy-Tool-for-Rails deploy
$ cd deploy/
$ echo '<Rails-app path> <root-user password>' >> pathpass.txt
$ touch log.txt
```

**Rails-app path**: Rails-app root (in this case, `/var/www/example`)  
**root-user password**: this is used to restart Apache (`$ sudo service httpd restart`)  

At lsat, GitHub WebHooks.  
In your repositries, [Settings]→[Webhooks & Services]→[Add Webhook].  
And set URL to send POST request. (in this case, `http://deploy.example.com`)  

That's all !

## 日本語の説明
[ブログ記事](http://www.showwin.asia/2014/07/30/%E3%80%90rails%E3%80%91github-webhooks-sinatra%E3%81%A7%E8%87%AA%E5%8B%95%E3%83%87%E3%83%97%E3%83%AD%E3%82%A4%E7%92%B0%E5%A2%83%E3%82%92%E4%BD%9C%E3%81%A3%E3%81%9F/)に書きました。

