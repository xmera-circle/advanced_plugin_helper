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

require File.expand_path('../../../test_helper', __dir__)

module AdvancedPluginHelper
  class TestKlass; end
  module TestPatch; end

  class RegistryTest < ActiveSupport::TestCase
    setup do
      AdvancedPluginHelper::Patch::Registry.clear
    end

    test 'should return empty array when nothing registered' do
      assert_equal [], AdvancedPluginHelper::Patch::Registry.all
    end

    test 'should register data' do
      data = { klass: TestKlass, patch: TestPatch, strategy: nil }
      AdvancedPluginHelper::Patch::Registry.add(data)
      first_data = AdvancedPluginHelper::Patch::Registry.all.first
      assert_equal data[:klass], first_data.klass
      assert_equal data[:patch], first_data.patch
      assert_equal :include, first_data.strategy
    end
  end
end
