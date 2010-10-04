#
# rb_main.rb
# KVCFun
#
# Created by Caio Chassot on 2010-10-03.
# Copyright __MyCompanyName__ 2010. All rights reserved.
#

# Loading the Cocoa framework. If you need to load more frameworks, you can do that here too.
framework 'Cocoa'

# Loading all the Ruby project files.
[__FILE__].concat(Dir[File.join(NSBundle.mainBundle.resourcePath.fileSystemRepresentation, '*.{rb,rbo}')])
  .map  { |path| File.basename(path, File.extname(path)) }.uniq[1..-1]
  .each { |name| require(name) }

# Starting the Cocoa main loop.
NSApplicationMain(0, nil)
