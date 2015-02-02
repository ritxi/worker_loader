# encoding: utf-8
require 'active_support/core_ext/module/attribute_accessors'

# Resque workers strategy
# loading system
module WorkersLoader
  mattr_accessor :workers_paths
  @@workers_paths = []

  mattr_accessor :workers
  @@workers = []

  mattr_accessor :resque_mailer
  @@resque_mailer = false

  class << self
    def add_path(path, parent = true)
      fail "Directory not found: `#{path}`" unless Dir.exist?(path)
      @@workers_paths << Path.new(path, parent)
    end

    def load_workers!
      workers_paths.each do |path|
        workers_in_path = path.find
        next if workers_in_path.empty?

        duplacates = workers_in_path
          .select { |worker| workers.include?(worker) }
          .sort.join(', ')
        fail("Workers already present! #{duplacates}") unless duplacates.blank?

        self.workers += workers_in_path
      end

      resque_mailer_install
    end

    def resque_mailer_install
      return if !resque_mailer? || self.workers.include?(:mailer)
      self.workers << :mailer
    end

    def resque_mailer!
      @@resque_mailer = true
    end

    def resque_mailer?
      @@resque_mailer
    end
  end

  autoload :Path, 'workers_loader/path'
end
