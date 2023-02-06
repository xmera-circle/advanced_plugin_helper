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
    module SubclassPatch
      extend ActiveSupport::Concern

      included do
        # @override ActiveRecord::Associations::association
        #
        # There is a bug in Rails reported already in 2015 concerning
        # associations and subclasses. See https://github.com/rails/rails/issues/20678.
        #
        # Whenever a superclass gets further associations its subclass, which was
        # defined before the superclass will be extended, won't reflect those
        # additional associations.
        #
        # The code below fixes this problem by getting the reflection of the
        # superclass if the subclass does not have any. Finally, the association
        # instance will be set as stated in the last line within the if block.
        #
        # Returns the association instance for the given name, instantiating it if it doesn't already exist
        def association(name) # :nodoc:
          association = association_instance_get(name)

          if association.nil?
            reflection = find_reflection(name)
            raise AssociationNotFoundError.new(self, name) unless reflection

            association = reflection.association_class.new(self, reflection)
            association_instance_set(name, association)
          end

          association
        end

        def find_reflection(name)
          self.class._reflect_on_association(name) || self.class.superclass._reflect_on_association(name)
        end
      end
    end
  end
end
