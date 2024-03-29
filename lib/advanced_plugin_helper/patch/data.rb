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
  module Patch
    ##
    # Holds the data required for applying a Redmine patch.
    #
    class Data
      STRATEGIES = %i[prepend include helper].freeze

      attr_reader :klass, :patch, :strategy

      def initialize(**data)
        self.klass = data[:klass]
        self.patch = data[:patch]
        strategy = data[:strategy]
        self.strategy = STRATEGIES.include?(strategy&.to_sym) ? strategy : :include
      end

      private

      attr_writer :klass, :patch, :strategy
    end
  end
end
