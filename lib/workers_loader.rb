# encoding: utf-8
require 'active_support/core_ext/module/attribute_accessors'

# Resque workers strategy
# loading system
module WorkersLoader
  mattr_accessor :workers_paths
  @@workers_paths = []

  mattr_accessor :workers
  @@workers = []

  autoload :Path, 'workers_loader/path'
end
