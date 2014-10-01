node[:deploy].each do |application, deploy_config|

	app_dir = "/opt/#{deploy_config[:application]}"

	git app_dir  do
		repository deploy_config[:scm][:repository]
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


