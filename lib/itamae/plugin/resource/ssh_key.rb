require "open-uri"
require "itamae/resource/file"

module Itamae
  module Plugin
    module Resource
      class SshKey < ::Itamae::Resource::File
        define_attribute :username, type: String, default_name: true
        define_attribute :github_user, type: String
        define_attribute :key_file, type: String
        define_attribute :ssh_keys, type: [String, Array]

        def action_create(options)
          return unless user_exist?
          create_ssh_directory unless current.dir_exist
          super
        end

        def pre_action
          return unless user_exist?
          set_attributes
          super
        end

        def set_current_attributes
          return unless user_exist?
          super

          current.dir_exist = run_specinfra(:check_file_is_directory, ssh_directory)
          if current.dir_exist
            current.dir_mode  = current_ssh_directory_mode
            current.dir_owner = current_ssh_directory_owner
            current.dir_group = current_ssh_directory_group
          end
        end

        def show_differences
          current.mode = current.mode.rjust(4, "0") if current.mode
          current.dir_mode = current.dir_mode.rjust(4, "0") if current.dir_mode

          super
        end

        private

        def content_file
          if attributes.ssh_keys
            nil
          else
            attributes.key_file
          end
        end

        def create_ssh_directory
          run_specinfra(:create_file_as_directory, ssh_directory)
          run_specinfra(:change_file_mode, ssh_directory, attributes.dir_mode)
          run_specinfra(:change_file_owner, ssh_directory, attributes.dir_owner, attributes.dir_group)
        end

        def current_ssh_directory_mode
          run_specinfra(:get_file_mode, ssh_directory).stdout.strip
        end

        def current_ssh_directory_owner
          run_specinfra(:get_file_owner_user, ssh_directory).stdout.strip
        end

        def current_ssh_directory_group
          run_specinfra(:get_file_owner_group, ssh_directory).stdout.strip
        end

        def home_directory
          run_specinfra(:get_user_home_directory, attributes.username).stdout.strip
        end

        def keys_from_github
          open("https://github.com/#{attributes.github_user}.keys").read
        end

        def keys_path
          ::File.join(ssh_directory, "authorized_keys")
        end

        def set_attributes
          attributes.content = ssh_keys
          attributes.mode    = "0600"
          attributes.owner   = attributes.username
          attributes.group   = attributes.username
          attributes.path    = keys_path

          attributes.dir_mode  = "0700"
          attributes.dir_owner = attributes.username
          attributes.dir_group = attributes.username
        end

        def ssh_directory
          @ssh_directory ||= ::File.join(home_directory, ".ssh")
        end

        def ssh_keys
          if attributes.ssh_keys
            [*attributes.ssh_keys].join("\n")
          elsif attributes.github_user
            keys_from_github
          else
            nil
          end
        end

        def user_exist?
          run_specinfra(:check_user_exists, attributes.username)
        end
      end
    end
  end
end
