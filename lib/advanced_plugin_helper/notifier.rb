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
  # Configuration of exception notifier
  #
  # @example In config/additional_environment.rb:
  #
  # require File.expand_path('plugins/advanced_plugin_helper/lib/advanced_plugin_helper/notifier', __dir__)
  # require File.expand_path('plugins/advanced_plugin_helper/lib/exception_notifier/custom_mail_notifier', __dir__)
  # require 'exception_notification/rails'
  #
  # ExceptionNotification.configure do |config|
  #   if AdvancedPluginHelper::Notifier.email_delivery_enabled?
  #     config.add_notifier :custom_mail, AdvancedPluginHelper::Notifier.custom_mail
  #     config.error_grouping = AdvancedPluginHelper::Notifier.error_grouping
  #     config.ignore_if do |exception, options|
  #       AdvancedPluginHelper::Notifier.disabled?
  #     end
  #   end
  # end
  #
  # In order to configure sender and recipients set the corresponding env vars:
  # EXCEPTION_NOTIFIER_SENDER (default: Setting.mail_from as set in Administration » Setting » Email notifications)
  # EXCEPTION_NOTIFIER_RECIPIENTS (default: Mail addresses of all admins)
  #
  # You can also disable the notifier via EXCEPTION_NOTIFIER_DISABLED (default: false).
  #
  module Notifier
    ##
    # Default exception report sections are
    # request, session, environment, backtrace. The last two
    # however, are ommited since they are less meaningful.
    #
    # The additonal section 'about' gives the same
    # information as retrieved with 'bin/about'.
    #
    # @see app/views/exception_notifier/_about.text.erb
    #
    # You can easyly extend the report by adding a further
    # section: AdvancedPluginHelper::Notifier.sections << (my_section)
    # and creating a partial as done for the about section.
    #
    mattr_accessor :sections
    self.sections = %w[backtrace request about]

    ##
    # Assign a comma separated list of email recipients maintaining
    # the system.
    #
    mattr_accessor :default_exception_recipients, instance_reader: false

    def self.default_exception_recipients
      class_variable_get(:@@default_exception_recipients) || ENV.fetch('DEFAULT_EXCEPTION_NOTIFIER_RECIPIENTS', nil)
    end

    ##
    # Read environment variable for notifier recipient customization.
    #
    mattr_accessor :custom_exception_recipients, instance_reader: false
    def self.custom_exception_recipients
      class_variable_get(:@@custom_exception_recipients) || ENV.fetch('EXCEPTION_NOTIFIER_RECIPIENTS', nil)
    end

    ##
    # Define the main variable which should hold all relevant recipients to
    # be called by exception_recipients below.
    #
    # @note The assignment will be done in lib/advanced_plugin_helper.rb.
    #
    #
    mattr_accessor :custom_or_default_recipients, instance_reader: false

    mattr_accessor :disabled, instance_reader: false
    def self.disabled?
      class_variable_get(:@@disabled) || ENV.fetch('EXCEPTION_NOTIFIER_DISABLED', false)
    end

    def self.custom_or_default_recipients
      "#{custom_exception_recipients}, #{default_exception_recipients}"
    end

    def self.email_delivery_enabled?
      !!ActionMailer::Base.perform_deliveries
    end

    def self.custom_mail
      { email_prefix: '[Exception] ',
        sender_address: sender_address,
        exception_recipients: exception_recipients,
        sections: sections }
    end

    def self.error_grouping
      true
    end

    def self.exception_recipients
      -> { custom_or_default_recipients }
    end

    def self.sender_address
      -> { custom_or_default_sender }
    end

    def self.custom_or_default_sender
      %("#{app_title}" <#{mail_from}>)
    end

    def self.mail_from
      custom_mail_from || setting(:mail_from)
    end

    def self.app_title
      setting(:app_title)
    end

    def self.custom_mail_from
      ENV.fetch('EXCEPTION_NOTIFIER_SENDER', nil)
    end

    def self.setting(attr)
      Setting.send attr
    end
  end
end
