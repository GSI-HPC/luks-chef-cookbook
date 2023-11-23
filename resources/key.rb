#
# Cookbook:: luks
# Recipe:: default
#
# Copyright:: 2023,  GSI Helmholtzzentrum fuer Schwerionenforschung GmbH
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Authors:
#   S.Hasert@gsi.de
#   C.Huhn@gsi.de

provides :luks_key

default_action :add

property :device, String, name_property: true
         # callbacks: {
         #   'should be an encrypted device' => lambda {
         #   }
         # }

property :passphrase,
         String,
         sensitive: true,
         regex: node['luks']['passphrase_acceptance_regex'],
         required: true

property :master_passphrase, String, sensitive: true, desired_state: false, required: false,
         default: chef_vault_item(
           node['luks']['master_passphrase']['vault'],
           node['luks']['master_passphrase']['vault_item']
         )['passphrase']

load_current_value do |new_resource|
  # shell command returns exit code 2 on exit & outputs to std::err if the passphrase is not used yet
  # the function checks if the action is *add*
  #   yes: the function checks if the shell command returns an error
  #     yes: the passphrase is not used yet & is added
  #     no: LUKS(2) knows the passphrase & nothing is done
  # the function then checks if the actions is *remove*
  #   yes: the function checks if the shell command returns an error
  #     yes: the passphrase is not used yet & nothing gets deleted 
  #     no: the passphrase is used & gets deleted

  if new_resource.action.include? :add
    # check if passphrase has already been added
    cmd = Mixlib::ShellOut.new("cryptsetup luksOpen --test-passphrase #{new_resource.device}",
                               input: new_resource.passphrase)
    cmd.valid_exit_codes = [0,2]
    cmd.run_command
    case cmd.exitstatus
    when 0
      passphrase new_resource.passphrase # yes -> do nothing
    when 2
      current_value_does_not_exist! # no -> add
    end

  elsif new_resource.action.include? :remove
    # check if passphrase exists
     cmd = Mixlib::ShellOut.new("cryptsetup luksOpen --test-passphrase #{new_resource.device}",
                               input: new_resource.passphrase)
    cmd.valid_exit_codes = [0,2]
    cmd.run_command
    case cmd.exitstatus
    when 2
      passphrase new_resource.passphrase # no -> do nothing
    when 0
      current_value_does_not_exist! # yes -> remove
    end
  else
    current_value_does_not_exist!
  end
  # TODO: what happens if all keyslots are filled
  # but the given passphrase is not set?
  #   -Answer: "cryptsetup luksAddKey #{new_resource.device}" (shell command in :add) -> exit 1, std::err: All keyslots are full.
end

action :add do
  converge_if_changed do
    shell_out!("cryptsetup luksAddKey #{new_resource.device}",
               input: "#{new_resource.master_passphrase}\n#{new_resource.passphrase}\n")
  end
end

action :remove do
  converge_if_changed do
    shell_out!("cryptsetup luksRemoveKey #{new_resource.device}",
               input: new_resource.passphrase)
  end
end
