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

module AdvancedPluginHelper
  ##
  # BasePresenter to be used in views.
  # It is available in all views via PresenterHelper#show.
  # See app/helpers/advanced_plugin_helper/presenters_helper for further details.
  #
  # @example Using the BasePresenter class
  #
  # class SyncParamsPresenter < AdvancedPluginHelper::BasePresenter
  #   presents :sync_params
  #
  #   def tracker_list
  #     # method body here
  #   end
  # end
  #
  class BasePresenter < SimpleDelegator
    include ActionView::Helpers
    include Redmine::I18n

    delegate_missing_to :view

    ##
    # Dictionary for looking up presenter class names including their namespaces
    # with a given object class name.
    #
    # @example Registered presenters
    # { Issue: MyCustomPlugin::IssuePresenter, IssueQuery: MyCustomPlugin::IssueQueryPresenter }
    #
    def self.registered_presenters
      @registered_presenters ||= {}
    end

    ##
    # Register presenter class names in order to add them to the dictionary of
    # registered_presenters.
    #
    # @param presenter_class_name [Class] The full name of the presenter class, i.e., with namespaces.
    # @param for_object_classes [Array(Class)] A list with object classes the presenter belongs to.
    #
    def self.register(presenter_class_name, *for_object_classes)
      for_object_classes = [presenter_class_name.sub(/Presenter$/, '')] unless for_object_classes.any?
      for_object_classes.each do |name|
        registered_presenters[name.to_s] = presenter_class_name
      end
    end

    ##
    # @param object [Model object] The object which uses the presenter.
    #
    # @note This method is used in app/helpers/advanced_plugin_helper/presenters_helper.rb.
    #
    def self.klass(object)
      object_klass = object.class
      registered_presenters[object_klass.to_s] || "#{object_klass}Presenter".constantize
    end

    ##
    # Defines a (alias) name of the object to be used throughout the presenter
    # class.
    #
    # @param name [String|Symbol] The object name.
    #
    def self.presents(name)
      define_method(name) do
        object
      end
    end

    def initialize(object, view)
      super(@object)
      @object = object
      @view = view
    end

    private

    attr_reader :object, :view

    ##
    # This overrides AdvancedPluginHelper::BasePresenter#params to return view#params explicity.
    # Otherwise, calling params would lead to a stack overflow.
    #
    def params
      view.params
    end
  end
end
