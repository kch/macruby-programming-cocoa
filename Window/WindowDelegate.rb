#
#  WindowDelegate.rb
#  Window
#
#  Created by Caio Chassot on 2010-10-03.
#  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
#

class WindowDelegate

  def windowWillResize(sender, toSize:frameSize)
    CGSize.new(frameSize.height/2, frameSize.height)
  end

end
