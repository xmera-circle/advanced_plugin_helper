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

require File.expand_path('../test_helper', __dir__)

module AdvancedPluginHelper
  class PresentersHelperTest < Redmine::HelperTest
    include PresentersHelper

    def setup
      @patch = AdvancedPluginHelper::PresentersHelper
      data = AdvancedPluginHelper::Patch::Data.new(klass: ApplicationController,
                                                   patch: @patch,
                                                   strategy: :helper)
      AdvancedPluginHelper::Patch::Compatability::Base.send(:add_patch, data)
    end

    test 'should find PresentersHelper in ApplicationController' do
      assert ApplicationController.helpers.respond_to?(:show)
    end

    test 'should find PresentersHelper in all ApplicationController subclasses' do
      controller_path = Rails.root.join('app/controllers')
      controller_files = Dir.entries(controller_path)
      controller_klasses = controller_files.map do |file_name|
        File.basename(file_name, '.rb')
      end
      controller_klasses.each do |klass|
        controller_klass = to_class(klass)
        next unless controller_klass
        next unless controller_klass.is_a? ApplicationController

        assert controller_klass.included_modules.include?(@patch), "No patch in #{klass}"
      end
    end

    private

    def to_class(klass)
      return if %w[. ..].include?(klass)

      klass.classify.constantize
    rescue NameError => e
      raise "Filename #{klass} cannot be turned into controller class: #{e.message}"
    end
  end
end
