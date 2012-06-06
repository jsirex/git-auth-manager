require 'fileutils'
module CONNECTOR
  class GitConnector
    def initialize(config)
      @clone_path = config[:clone_path]
      @url = config[:url]
      @keydir = config[:keydir]
      @keydir_path = config[:clone_path] + '/' + config[:keydir]
      @disabled_path = config[:clone_path] + '/' + config[:disabled]
      @logmessage = ""
    end

    def inspect
      "#{@url} -> #{@clone_path} [#{@keydir}]"
    end

    def load
      if Dir.exist? @clone_path + "/.git" then
        puts pull_repo
      else
        puts clone_repo
      end
      Dir.mkdir @disabled_path unless Dir.exist? @disabled_path
    end

    def getUsers
      Dir[@keydir_path + '/*'].map do |pubfile|
        pubfile.match(/([^\/]+).pub$/)[1]
      end
    end

    def enableUsers(users)
      users.each do |user|
        if File.exist? "#{@disabled_path}/#{user}.pub" then
          FileUtils.mv "#{@disabled_path}/#{user}.pub", "#{@keydir_path}/#{user}.pub"
          puts "Enabled: #{user}."
          @logmessage += "Enabled: #{user}.\n"
        end
      end
    end

    def disableUsers(users)
      users.each do |user|
        if File.exist? "#{@keydir_path}/#{user}.pub" and user != "admin" # admin.pub keept for administrative reasons
          FileUtils.mv "#{@keydir_path}/#{user}.pub", "#{@disabled_path}/#{user}.pub"
          puts "Disabled: #{user}."
          @logmessage += "Disabled: #{user}.\n"
        end
      end
    end

    def save
      return if @logmessage.empty?
      commit @logmessage
      @logmessage = ""
      push_repo
    end

    private
    def clone_repo
      puts "Clonning #{@url} because no working copy exists"
      g = Git.clone(@url, @clone_path)
    end

    def pull_repo
      puts "Pulling #{@url} because found working copy"
      g = Git.open @clone_path
      g.pull
    end

    def commit(message)
      g = Git.open @clone_path
      g.add @keydir_path
      g.add @disabled_path
      g.commit_all(message)
    end

    def push_repo
      puts "Pushing changes"
      g = Git.open @clone_path
      g.push
    end
  end
end

# Hack
module Git
  class Base
    def pull(remote = 'origin', branch = 'master', message = 'origin pull')
      fetch(remote, branch)
      merge(branch, message)
    end

    def fetch(remote = 'origin', branch = 'master')
      self.lib.fetch(remote, branch)
    end
  end

  class Lib
    def fetch(remote, branch = 'master')
      command('fetch', [remote, branch])
    end
  end
end