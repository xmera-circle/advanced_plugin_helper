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
    class << self
      def email_delivery_enabled?
        !!ActionMailer::Base.perform_deliveries
      end

      def custom_mail
        { email_prefix: '[Exception] ',
          sender_address: sender_address,
          exception_recipients: exception_recipients }
      end

      def disabled?
        ENV.fetch('EXCEPTION_NOTIFIER_DISABLED', false)
      end

      def error_grouping
        true
      end

      private

      def sender_address
        -> { custom_or_default_sender }
      end

      def exception_recipients
        -> { custom_or_default_recipients }
      end

      def custom_or_default_sender
        %("#{app_title}" <#{mail_from}>)
      end

      def custom_or_default_recipients
        [custom_exception_recipients || admin_mails]
      end

      def custom_exception_recipients
        ENV.fetch('EXCEPTION_NOTIFIER_RECIPIENTS', nil)
      end

      def mail_from
        custom_mail_from || setting(:mail_from)
      end

      def admin_mails
        User.admin.map(&:mail)
      end

      def app_title
        setting(:app_title)
      end

      def custom_mail_from
        ENV.fetch('EXCEPTION_NOTIFIER_SENDER', nil)
      end

      def setting(attr)
        Setting.send attr
      end
    end
  end
end
