require "./config.rb"

define :setup_user, user_name: nil, key_source: nil do
  define_params = params

  user define_params[:user_name] do
    password PASSWORD
    create_home true
    shell "/bin/bash"
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
