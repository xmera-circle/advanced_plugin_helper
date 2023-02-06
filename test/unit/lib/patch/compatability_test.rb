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

require File.expand_path('../../../test_helper', __dir__)

module AdvancedPluginHelper
  class TestKlass; end
  module TestPatch; end

  class CompatabilityTest < ActiveSupport::TestCase
    test 'should derive major version' do
      major_version = AdvancedPluginHelper::Patch.send(:major, '5.2.8.1')
      assert_equal '5', major_version
    end

    test 'should find class of given version' do
      version_klass = AdvancedPluginHelper::Compatability::Prepare.find('5')
      assert_equal AdvancedPluginHelper::Compatability::Prepare::V5, version_klass
    end

    test 'should add patches' do
      values = { klass: TestKlass, patch: TestPatch, strategy: nil }
      data = AdvancedPluginHelper::Patch::Data.new(**values)
      assert_not data.klass.included_modules.include?(data.patch)
      AdvancedPluginHelper::Patch::Executor.send(:add_patch, data)
      assert data.klass.included_modules.include?(data.patch)
    end
  end
end
