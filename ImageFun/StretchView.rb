#
#  StretchView.rb
#  ImageFun
#
#  Created by Caio Chassot on 2010-10-10.
#  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
#

class StretchView < NSView
  attr_accessor :image, :opacity

  def initWithFrame(rect)
    super or return nil
    srand
    @path = NSBezierPath.new.tap do |path|
      path.lineWidth = 3.0
      path.moveToPoint randomPoint
      15.times { path.lineToPoint randomPoint }
      path.closePath
    end
    self.opacity = 1.0
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
    image.drawInRect(currentRect, fromRect:NSRect.new(NSZeroPoint, image.size), operation:NSCompositeSourceOver, fraction:opacity) if image
  end


  ### Mouse events

  def mouseDown(event)
    settingCurrentPoint(event) { @downPoint = @currentPoint }
  end

  def mouseDragged(event)
    settingCurrentPoint(event) { autoscroll(event) }
  end

  def mouseUp(event)
    settingCurrentPoint(event)
  end

  def currentRect
    NSRect.new *[@downPoint, @currentPoint].map(&:to_a).transpose.map(&:sort).map { |p, q| [p, q - p] }.transpose
  end


  ### Accessors

  def setImage(image)
    @image        = image
    @downPoint    = NSZeroPoint
    @currentPoint = NSPoint.new *[@downPoint, image.size].map(&:to_a).inject(&:zip).map { |p, q| p + q }
    setNeedsDisplay true
  end
  alias_method :image=, :setImage

  def setOpacity(f)
    @opacity = f
    setNeedsDisplay true
  end
  alias_method :opacity=, :setOpacity


  private

  def settingCurrentPoint(event)
    @currentPoint = convertPoint(event.locationInWindow, fromView:nil)
    yield if block_given?
    setNeedsDisplay true
  end
end
