# encoding: utf-8
require 'active_support/core_ext/module/attribute_accessors'

# Resque workers strategy
# loading system
module WorkersLoader
  mattr_accessor :workers_paths
  @@workers_paths = []

  mattr_accessor :workers
  @@workers = []

  class << self
    def add_path(path)
      fail "Directory not found: `#{path}`" unless Dir.exist?(path)
      @@workers_paths << path
    end

    def find(path)
      path = Path.new(path)
      path.files.map { |file| path.queue_for(file) }
        .reject(&:blank?)
    end

    def load_workers!
      workers_paths.each do |path|
        workers_in_path = find(path)
        next if workers_in_path.empty?

        duplacates = workers_in_path
          .select { |worker| workers.include?(worker) }
        if duplacates.any?
          fail("Workers already present! #{duplacates.join(', ')}")
        end

        self.workers += workers_in_path
      end
    end
  end

  autoload :Path, 'workers_loader/path'
end
