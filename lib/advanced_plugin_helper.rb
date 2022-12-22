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
      AdvancedPluginHelper::Presenters.autoload
      patches.each do |patch|
        data = send("#{patch}_controller_patch")
        AdvancedPluginHelper::Patch.register(data)
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
  end
end
