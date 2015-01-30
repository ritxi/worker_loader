# encoding: utf-8
require 'resque'

module WorkersLoader
  class Path
    attr_reader :base, :parent

    def initialize(base, parent = true)
      base = match[1] if match = /(.*)\/$/.match(base)
      @base = base

      @parent = base.split('/').last if parent
    end

    def files
      path = File.join(base, '{**/*.rb}')
      Dir[path]
        .map { |file| /#{base}\/(.*).rb/.match(file)[1] }
        .map { |relative_path| relative_path_for(relative_path) }
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

    def relative_path_for(path)
      parent.nil? ? path : File.join(parent, path)
    end
    private :relative_path_for
  end
end
