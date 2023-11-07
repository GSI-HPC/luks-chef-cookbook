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

# resource_name :luks_key # see: <https://docs.chef.io/custom_resources_notes/>
provides :luks_key

default_action :add

property :device, String, name_property: true
=begin
         callbacks: {
           'should be an encrypted device' => lambda {
             # check whether device is a valid and open cryptsetup device
           }
         }
=end
property :passphrase, String, sensitive: true,
         # FIXME: comment regex
         regex: %r{^[1234567890qwertuiopasdfghjklxcvbnm
                     ,.!$%QWERTUPASDFHJKLXCVBNM]{12,42}$
                }x,
         required: true

load_current_value do |new_resource|
  # 1. check if passphrase has already been added
  # 2. check if the luks keyslots are accessibe to the Chef key
  current_value_does_not_exist!
  # TODO: what happens if all keyslots are filled
  #  but the given passphrase is not set?
  # 3. Throw error if we cannot open the luks keyslots
end

action :add do
  converge_if_changed do
    # add passphrase
    shell_out!("cryptsetup luksAddKey /tmp/cryptokitchen.loop", input: "dummbabbler\n#{new_resource.passphrase}\n")
  end
end

action :remove do
  converge_if_changed do
    shell_out!("cryptsetup luksRemoveKey /tmp/cryptokitchen.loop", input: new_resource.passphrase)
  end
end
