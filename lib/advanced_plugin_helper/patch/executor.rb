# frozen_string_literal: true

# This file is part of the Advanced Plugin Helper plugin.
#
# Copyright (C) 2023 Liane Hampe <liaham@xmera.de>, xmera Solutions GmbH.
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
    module Executor
      class << self
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
  end
end
