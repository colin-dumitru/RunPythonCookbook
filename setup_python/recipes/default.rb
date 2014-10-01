package "python2.7" do
  action :install
end

package "python-pip" do
  action :install
end

bash "install_boto" do
	user "root"
	code <<-EOH
	pip install boto
	EOH
end