#
#  StretchView.rb
#  ImageFun
#
#  Created by Caio Chassot on 2010-10-10.
#  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
#

class StretchView < NSView

  def initWithFrame(rect)
    super or return nil
    srand
    @path = NSBezierPath.new.tap do |path|
      path.lineWidth = 3.0
      path.moveToPoint randomPoint
      15.times { path.lineToPoint randomPoint }
      path.closePath
    end
    self
  end

  def randomPoint
    r = bounds
    NSPoint.new(
      r.origin.x + rand(r.size.width),
      r.origin.y + rand(r.size.height))
  end

  def drawRect(rect)
    NSColor.greenColor.set
    NSBezierPath.fillRect(bounds)
    NSColor.whiteColor.set
    @path.fill
  end

end
