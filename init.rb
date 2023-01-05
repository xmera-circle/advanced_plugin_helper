# frozen_string_literal: true

# This file is part of the Advanced Plugin Helper plugin.
#
# Copyright (C) 2022-2023 Liane Hampe <liaham@xmera.de>, xmera Solutions GmbH.
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

require File.expand_path('lib/advanced_plugin_helper', __dir__)

Redmine::Plugin.register :advanced_plugin_helper do
  name 'Advanced Plugin Helper'
  author 'Liane Hampe, xmera Solutions GmbH'
  description 'Encapsulate presentation logic in PORO'
  version '0.2.0'
  url 'https://circle.xmera.de/projects/advanced-plugin-helper'
  author_url 'https://github.com/liaham'

  requires_redmine version_or_higher: '4.2.0'
end

AdvancedPluginHelper.setup
