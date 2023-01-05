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

namespace :redmine do
  namespace :plugins do
    namespace :test do
      desc 'Runs the plugins helper tests.'
      task helpers: 'db:test:prepare' do |_t|
        $LOAD_PATH << 'test'
        Rails::TestUnit::Runner.rake_run ["plugins/#{ENV['NAME'] || '*'}/test/helpers/**/*_test.rb"]
      end
    end

    desc 'Runs the plugins tests.'
    task :test do
      Rake::Task['redmine:plugins:test:units'].invoke
      Rake::Task['redmine:plugins:test:functionals'].invoke
      Rake::Task['redmine:plugins:test:helpers'].invoke
      Rake::Task['redmine:plugins:test:integration'].invoke
      Rake::Task['redmine:plugins:test:system'].invoke
    end
  end
end
