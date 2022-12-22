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
  # Will add for all plugins presenters directory (if any) to
  # autoload path when using Rails 5.
  #
  module Presenters
    class << self
      def autoload
        return if Rails.version >= '6'

        plugin_dirs.each do |plugin_dir|
          next unless Dir.exist?(send(:path, plugin_dir))

          autoload_path(plugin_dir)
        end
      end

      def path(plugin)
        Rails.root.join('plugins', plugin, 'app', 'presenters')
      end

      private

      def autoload_path(plugin_dir)
        Rails.application.configure do
          config.autoload_paths << AdvancedPluginHelper::Presenters.path(plugin_dir)
        end
      end

      def plugin_dirs
        Rails.root.join('plugins').entries - %w[. .. README]
      end
    end
  end
end
