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
  ##
  # AdvancedPluginHelper::Patch is the API to be used by Redmine plugin authors.
  #
  module Patch
    class << self
      ##
      # @param data [Hash] Required keys are :klass, :patch, :strategy
      #                    where :klass is the class which should be patched
      #                    and :patch is the patch for doing so and :strategy
      #                    describes whether to :include or :prepend the patch.
      #
      # @example
      #   data = { klass: Issue, patch: MyPlugin::Extensions::IssuePatch, strategy: :prepend }
      #
      def register(data)
        AdvancedPluginHelper::Patch::Registry.add(data)
      end

      def apply
        version = major(Rails.version)
        klass = AdvancedPluginHelper::Patch::Compatability.find(version)
        klass.apply
      end

      private

      def major(version)
        version.to_s.split('.')[0]
      end
    end
  end
end
