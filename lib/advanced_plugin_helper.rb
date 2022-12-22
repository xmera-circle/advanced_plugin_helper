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

##
# Setup methods for this plugin.
#
module AdvancedPluginHelper
  class << self
    def setup
      autoload_presenters
      patches.each do |patch|
        AdvancedPluginHelper::Patch.register(send("#{patch}_controller_patch"))
      end
      AdvancedPluginHelper::Patch.apply
    end

    private

    def patches
      %w[application settings projects queries]
    end

    def application_controller_patch
      { klass: ApplicationController,
        patch: AdvancedPluginHelper::PresentersHelper,
        strategy: :helper }
    end

    def settings_controller_patch
      { klass: SettingsController,
        patch: AdvancedPluginHelper::PresentersHelper,
        strategy: :helper }
    end

    def projects_controller_patch
      { klass: ProjectsController,
        patch: AdvancedPluginHelper::PresentersHelper,
        strategy: :helper }
    end

    def queries_controller_patch
      { klass: QueriesController,
        patch: AdvancedPluginHelper::PresentersHelper,
        strategy: :helper }
    end

    def autoload_presenters
      plugin_dirs.each do |plugin_dir|
        next unless Dir.exist?(plugin_presenters_dir(plugin_dir))

        Rails.application.configure do
          config.autoload_paths << AdvancedPluginHelper.send(:plugin_presenters_dir, plugin_dir)
        end
      end
    end

    def plugin_dirs
      Rails.root.join('plugins').entries - %w[. .. README]
    end

    def plugin_presenters_dir(plugin)
      Rails.root.join('plugins', plugin, 'app', 'presenters')
    end
  end
end
