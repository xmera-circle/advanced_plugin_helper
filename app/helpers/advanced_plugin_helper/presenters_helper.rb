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

module AdvancedPluginHelper
  ##
  # Initializes presenters
  #
  module PresentersHelper
    ##
    # Provides an interface for using presenters in views.
    #
    # @note redmine_extensions gem uses a similar approach
    # ApplicationHelper#present. Therefore, this needs to be
    # named PresenterHelper#show.
    #
    # @example show(@sync_param).tracker_list
    #
    def show(object, klass = nil)
      klass ||= BasePresenter.klass(object)
      presenter = klass.new(object, self)
      yield presenter if block_given?
      presenter
    end
  end
end
