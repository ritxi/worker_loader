# encoding: utf-8
require 'resque'

module WorkersLoader
  class Path
    attr_reader :base, :parent

    def initialize(base, parent = true)
      base = match[1] if match = /(.*)\/$/.match(base)
      path = base.split('/')
      @parent = path.pop if parent
      @base = path.join('/')
    end

    def files
      path = File.join(base_with_parent, '{**/*.rb}')
      Dir[path]
        .map { |file| /#{base}\/(.*).rb/.match(file)[1] }
    end

    def find
      files.map { |file| queue_for(file) }
        .reject(&:blank?)
    end

    def class_for(relative_path)
      relative_path.split('/').map(&:camelize).join('::').constantize
    rescue NameError
      file = File.join(base, "#{relative_path}.rb")
      raise "File not found: #{file}" unless File.exist?(file)
      load file
      class_for(relative_path)
    end

    def queue_for(relative_path)
      Resque.queue_from_class(class_for(relative_path))
    end

    def base_with_parent
      parent.nil? ? base : File.join(base, parent)
    end
  end
end
