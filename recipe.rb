require "./config.rb"

define :setup_user, user_name: nil, key_source: nil do
  define_params = params

  user define_params[:user_name] do
    password PASSWORD
    create_home true
  end

  user define_params[:user_name] do
    shell "/bin/bash"
    not_if "bash -c '[[ `getent passwd #{define_params[:user_name]}` == */bin/* ]]'"
  end

  directory "/home/#{define_params[:user_name]}/.ssh" do
    owner define_params[:user_name]
    group define_params[:user_name]
    mode  "700"
  end

  remote_file "/home/#{define_params[:user_name]}/.ssh/authorized_keys" do
    source define_params[:key_source]
    owner define_params[:user_name]
    group define_params[:user_name]
    mode  "600"
  end
end

users = %w(nonylene tyage lastcat)

# user create and put keys
users.each do |user|
  setup_user 'create user' do
    user_name user
    key_source "files/keys/#{user}.keys"
  end
end

# sudoers
template "/etc/sudoers.d/neko-sudoers" do
  source "templates/neko-sudoers.erb"
  mode   "440"
  owner  "root"
  group  "root"
  variables(users: users)
end

%w(zsh tmux git tig vim p7zip-full).each {|pack| package pack}

# symlink

remote_file "/opt/symlink.sh" do
  source "files/symlink.sh"
  owner "root"
  group "root"
  mode  "777"
end

# dumps
%w(perl libdbi-perl libdbd-mysql-perl libterm-readkey-perl libio-socket-ssl-perl libgdbm3 libnet-ssleay-perl).each {|pack| package pack}

percona_deb_file = "/tmp/percona.deb"

execute "get percona_deb_file" do
  command "curl https://www.percona.com/downloads/percona-toolkit/2.2.17/deb/percona-toolkit_2.2.17-1_all.deb > #{percona_deb_file}"
  not_if "type pt-query-digest"
end

execute "dpkg -i #{percona_deb_file}" do
  not_if "type pt-query-digest"
end

directory "/opt" do
  owner "root"
  group "root"
  mode  "777"
end

directory "/opt/bin" do
  owner "root"
  group "root"
  mode  "777"
end

directory "/var/log/mysql/old/" do
  owner "root"
  group "root"
  mode  "777"
end

directory "/var/log/mysql/slow-query/" do
  owner "root"
  group "root"
  mode  "777"
end

directory "/var/log/nginx/" do
  mode  "755"
end

directory "/var/log/nginx/old/" do
  owner "root"
  group "root"
  mode  "777"
end

template "/opt/bin/dump-slow-and-notify.sh" do
  source "templates/dump-slow-and-notify.sh.erb"
  mode   "775"
  owner  "root"
  group  "root"
  variables(slack_channels: SLACK_CHANNELS, slack_token: SLACK_TOKEN)
end
