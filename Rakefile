require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "tempfile"
require "net/ssh"

VAGRANT_HOSTNAME = "ipr-sshkey-spec"

desc "Run provisining vagrant and serverspec tests"
task integration: ["integration:provision", "integration:spec"]

namespace :integration do
  desc "Provision Vagrant"
  task :provision do
    env = {"VAGRANT_CWD" => File.expand_path("./spec/integration")}
    tmp_ssh_config = Tempfile.new("", Dir.tmpdir)

    Bundler.with_clean_env do
      system(env, "vagrant up #{VAGRANT_HOSTNAME}") || abort
      system(env, "vagrant ssh-config #{VAGRANT_HOSTNAME} > #{tmp_ssh_config.path}") || abort

      ssh_option = Net::SSH::Config.for(VAGRANT_HOSTNAME, [tmp_ssh_config.path])

      cmd = [
        "bundle exec itamae ssh",
        "-h #{ssh_option[:host_name]}",
        "-u #{ssh_option[:user]}",
        "-p #{ssh_option[:port]}",
        "-i #{ssh_option[:keys].first}",
        "-l debug",
        "spec/integration/recipe.rb"
      ]

      cmd << "--dry-run" if ENV["DRY_RUN"]

      cmd_str = cmd.join(" ")
      puts cmd_str
      system(cmd_str) || abort
    end
  end

  desc "Run serverspec tests"
  RSpec::Core::RakeTask.new(:spec) do |t|
    ENV["TARGET_HOST"] = VAGRANT_HOSTNAME
    t.ruby_opts = "-I ./spec/integration"
    t.pattern = "spec/integration/*_spec.rb"
  end
end
