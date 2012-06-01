module CONNECTOR
  class GitConnector
    def initialize(config)
      @clone_path = config[:clone_path]
      @url = config[:url]
      @keydir = config[:keydir]
      @keydir_path = config[:clone_path] + '/' + config[:keydir]
      @disabled_path = config[:clone_path] + '/disabled'
    end

    def inspect
      "#{@url} -> #{@clone_path} [#{@keydir}]"
    end

    def prepare
      if Dir.exist? @clone_path + "/.git" then
        pull_repo
      else
        clone_repo
      end
    end

    def getUsers
      Dir[@keydir_path + '/*'].map do |pubfile|
        pubfile.match(/([^\/]+).pub$/)[1]
      end

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
      g.commit(message)
    end

    def push_repo
      puts "Pushing changes"
      g = Git.open @clone_path
      g.push
    end
  end
end