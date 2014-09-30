package 'python2.7' do
  action :install
end

directory "/opt/worker" do
    mode 0755
    action :create
end

node[:deploy].each do |application, deploy|
	link deploy[:deploy_to] do
		to "/opt/worker"
		action :create
	end
end