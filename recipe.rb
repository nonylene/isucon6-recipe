require "./config.rb"

define :setup_user, user_name: nil, key_source: nil do
  define_params = params

  user define_params[:user_name] do
    password PASSWORD
    create_home true
  end

  user define_params[:user_name] do
    shell "/bin/bash"
    only_if "bash -c '[[ `getent passwd #{define_params[:user_name]}` == */bin/sh* ]]'"
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


# dumps
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
