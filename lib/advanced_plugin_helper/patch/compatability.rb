# frozen_string_literal: true

# This file is part of the Advanced Plugin Helper plugin.
#
# Copyright (C) 2022 Liane Hampe <liaham@xmera.de>, xmera Solutions GmbH.
#
# This plugin program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

module AdvancedPluginHelper
  module Patch
    ##
    # The Compatability ensures the appropriate loading of patches in dependence
    # of the current Rails and Redmine version.
    #
    module Compatability
      class << self
        ##
        # @see https://github.com/rails/rails/blob/e74526814a4151b59cf6c5c9787adbb3c4fe49aa/activerecord/lib/active_record/migration/compatibility.rb
        #      for a similar approach.
        #
        def find(version)
          version = version.to_s
          name = "V#{version.tr('.', '_')}"
          unknown_patch_api_version(name)
          const_get(name)
        end

        private

        def unknown_patch_api_version(name)
          return if const_defined?(name)

          versions = constants.grep(/\AV[0-9_]+\z/).map do |klass_name|
            klass_name.to_s.delete('V').tr('_', '.').inspect
          end

          raise ArgumentError,
                "Unknown patch API version #{version.inspect}; expected one of #{versions.sort.join(', ')}"
        end
      end

      ##
      # The base interface declaring the required methods.
      #
      class Base
        class << self
          def apply
            raise NotImplementedError, "#{self.class.name}##{method_name} needs to be implemented"
          end

          def add_registered_patches
            AdvancedPluginHelper::Patch::Registry.all.each do |data|
              add_patch(data)
            end
          end

          private

          def add_patch(data)
            patch = data.patch
            klass = data.klass
            return if klass.included_modules.include?(patch)

            klass.send(data.strategy, patch)
          end
        end
      end

      ##
      # Apply patches when running with Rails 5.
      #
      class V5 < Base
        def self.apply
          Rails.configuration.to_prepare do
            Base.add_registered_patches
          end
        end
      end

      ##
      # Apply patches when running with Rails 6.
      #
      class V6 < Base
        def self.apply
          Class.new(Redmine::Hook::ViewListener) do
            def after_plugins_loaded(_context = {})
              Base.add_registered_patches
            end
          end
        end
      end
    end
  end
end
