#
# rb_main.rb
# RaiseMan
#
# Created by Caio Chassot on 2010-10-03.
# Copyright __MyCompanyName__ 2010. All rights reserved.
#

# Loading the Cocoa framework. If you need to load more frameworks, you can do that here too.
framework 'Cocoa'

# store any new classes created during the requires that follow
LOADED_RUBY_CLASSES = []
class << Object
  def inherited(m)
    LOADED_RUBY_CLASSES << m
  end
end

# Loading all the Ruby project files.
[__FILE__].concat(Dir[File.join(NSBundle.mainBundle.resourcePath.fileSystemRepresentation, '*.{rb,rbo}')])
  .map  { |path| File.basename(path, File.extname(path)) }.uniq[1..-1]
  .each { |name| require(name) }

# Call _initialize on classes that respond to it. Same caveats as +initialize apply, e.g. it'll be called on subclasses
LOADED_RUBY_CLASSES.select { |k| k.respond_to?(:_initialize) }.each(&:_initialize)

# stop watching for new classes
class << Object
  remove_method :inherited
end

# Starting the Cocoa main loop.
NSApplicationMain(0, nil)
