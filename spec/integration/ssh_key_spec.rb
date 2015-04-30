require "spec_helper"

keys_file = File.expand_path("../keys", __FILE__)
keys = File.read(keys_file).lines.map(&:chomp)

shared_examples_for "ssh_key" do |user, keys|
  describe file("/home/#{user}/.ssh") do
    it { should be_directory }
    it { should be_mode 700 }
    it { should be_owned_by user }
    it { should be_grouped_into user }
  end

  describe file("/home/#{user}/.ssh/authorized_keys") do
    it { should be_file }
    it { should be_mode 600 }
    it { should be_owned_by user }
    it { should be_grouped_into user }
    it { should contain keys }
  end
end

describe "Itamae::Plugin::Resource::SshKey" do
  it_should_behave_like "ssh_key", "test01", keys[0]
  it_should_behave_like "ssh_key", "test02", keys.join("\n")
  it_should_behave_like "ssh_key", "test03", keys.join("\n")
  it_should_behave_like "ssh_key", "test04", keys.join("\n")
end
