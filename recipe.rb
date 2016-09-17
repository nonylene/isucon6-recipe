require "./config.rb"

define :setup_user, user_name: nil, key_source: nil do
  p = params

  user p[:user_name] do
    password PASSWORD
    create_home true
    shell "/bin/bash"
  end

  directory "/home/#{p[:user_name]}/.ssh" do
    owner p[:user_name]
    group p[:user_name]
    mode  "700"
  end

  remote_file "/home/#{p[:user_name]}/.ssh/authorized_keys" do
    source p[:key_source]
    owner p[:user_name]
    group p[:user_name]
    mode  "600"
  end
end

users = %w(nonylene)

users.each do |user|
  setup_user 'create user' do
    user_name user
    key_source "files/keys/#{user}.keys"
  end
end

template "/etc/sudoers.d/neko-sudoers.conf" do
  source "templates/neko-sudoers.conf.erb"
  mode   "440"
  owner  "root"
  group  "root"
  variables(users: users)
end
