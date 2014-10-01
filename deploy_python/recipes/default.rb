node[:deploy].each do |application, deploy_config|

	app_dir = "/opt/#{deploy_config[:application]}"

	# Create directory to store privat ssh key and wrapper script
	directory "/tmp/ssh" do
		owner 'root'
		mode '0644'
		action :create
	end

	# Create private ssh key from the scm bucket
	file "/tmp/ssh/#{deploy_config[:application]}.pem" do
		content deploy_config[:scm][:ssh_key]
		owner 'root'
		mode '400'
	end

	# Create a SSH wrapper script
	file "/tmp/ssh/wrapper.ssh" do
		content <<-EOH
		#!/usr/bin/env bash 
 		/usr/bin/env ssh -o "StrictHostKeyChecking=no" -i "/tmp/ssh/#{deploy_config[:application]}.pem" \$1 \$2
 		EOH

		owner 'root'
		mode '700'
	end	 

	# Clone the latest worker source code
	git app_dir  do
		repository deploy_config[:scm][:repository]
		ssh_wrapper "/tmp/ssh/wrapper.ssh"
		action :sync
	end

	# Run th worker in the background
	bash "run_app" do
		user "root"
		cwd app_dir
		code <<-EOH
		python2.7 application.py
		EOH
	end
	
end


