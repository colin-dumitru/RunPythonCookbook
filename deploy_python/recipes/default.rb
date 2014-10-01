node[:deploy].each do |application, deploy_config|

	app_dir = "/opt/#{deploy_config[:application]}"

	file "/tmp/ssh/#{deploy_config[:application]}.pem" do
		content deploy_config[:scm][:ssh_key]
		owner 'root'
		group 'group'
		mode '640'
	end

	file "/tmp/ssh/wrapper.ssh" do
		content <<-EOH
		#!/usr/bin/env bash 
 		/usr/bin/env ssh -o "StrictHostKeyChecking=no" -i "/tmp/ssh/#{deploy_config[:application]}.pem" \$1 \$2
 		EOH

		owner 'root'
		group 'group'
		mode '700'
	end	 

	git app_dir  do
		repository deploy_config[:scm][:repository]
		ssh_wrapper "/tmp/ssh/wrapper.ssh"
		action :sync
	end

	bash "run_app" do
		user "root"
		cwd app_dir
		code <<-EOH
		python2.7 application.py
		EOH
	end
	
end


