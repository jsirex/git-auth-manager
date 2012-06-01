#!/usr/bin/env ruby
require 'rubygems'
require 'daemons'

Daemons.run('git-auth-manager.rb', :app_name => 'git-auth-manager', :log_output => true)

