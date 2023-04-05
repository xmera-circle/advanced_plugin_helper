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
  module Associations
    class << self
      ##
      # @param subklass [Object] A subclass of an ActiveRecord Model class. The
      #                          superclass has some associations which should be
      #                          available to the given subclass.
      #
      def register(subklass)
        data = { klass: subklass,
                 patch: AdvancedPluginHelper::Associations::SubclassPatch,
                 strategy: :include }
        AdvancedPluginHelper::Patch.register(data)
      end
    end
  end
end
