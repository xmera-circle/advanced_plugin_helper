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

require File.expand_path('../../app/presenters/advanced_plugin_helper/base_presenter', __dir__)
require File.expand_path('../test_helper', __dir__)

module AdvancedPluginHelper
  GREETINGS = 'Hello!'
  class TestObject; end

  class TestObjectPresenter < BasePresenter
    presents :test_object

    def greetings
      GREETINGS
    end
  end

  class ApplicationControllerPatch < ActionController::TestCase
    tests ApplicationController

    test 'should respond to PresentersHelper#show' do
      assert_respond_to @controller.view_context, :show
    end

    test 'should execute presenter instance method' do
      test_object = TestObject.new
      assert_equal GREETINGS, @controller.view_context.show(test_object).greetings
    end
  end
end
