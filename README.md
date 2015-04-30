# Itamae::Plugin::Resource::SshKey

This gem is an itamae plugin resource to provide user's SSH public key.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'itamae-plugin-resource-ssh_key'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install itamae-plugin-resource-ssh_key

## Usage

In your recipe:

```ruby
require "itamae/plugin/resource/ssh_key"

user "user01"
ssh_key "user01" do
  ssh_keys "ssh-rsa A..."
end

user "user02"
ssh_key "user02" do
  ssh_keys ["ssh-rsa A...", "ssh-rsa A..."]
end

user "user03"
ssh_key "user03" do
  key_file "/home/user/.ssh/id_rsa.pub"
end

# Import SSH keys from github user.
user "user04"
ssh_key "user04" do
  github_user "user04"
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/itamae-plugin-resource-ssh_key/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
