bash "process_places_requests" do
	user "root"
	cwd "/opt/worker"
	code <<-EOH
	python2.7 application.py
	EOH
end