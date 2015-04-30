require "itamae/plugin/resource/ssh_key"
require "webmock"
Object.send(:include, WebMock::API)

keys_file = File.expand_path("../keys", __FILE__)
keys = File.read(keys_file).lines.map(&:chomp)

user "test01"
ssh_key "test01" do
  ssh_keys keys[0]
end

user "test02"
ssh_key "test02" do
  ssh_keys keys
end

user "test03"
ssh_key "test03" do
  key_file keys_file
end

stub_request(:get, "https://github.com/test04.keys").
  to_return(:status => 200, :body => keys.join("\n"), :headers => {})
user "test04"
ssh_key "test04" do
  github_user "test04"
end
