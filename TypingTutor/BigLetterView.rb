#
#  BigLetterView.rb
#  TypingTutor
#
#  Created by Caio Chassot on 2010-10-12.
#  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
#

class BigLetterView < NSView
  attr_accessor :string, :bgColor

  def initWithFrame(rect)
    super or return nil
    @bgColor, @string = NSColor.yellowColor, " "
    self
  end


  ### Accessors

  def setBgColor(color)
    @bgColor = color
    setNeedsDisplay true
  end
  alias_method :bgColor=, :setBgColor

  def setString(s)
    @string = s
    NSLog("The string is now #{s.inspect}")
  end
  alias_method :string=, :setString


  ### Drawing

  def isOpaque
    true
  end

  def drawRect(rect)
    bgColor.set
    NSBezierPath.fillRect(bounds)
    return unless window.firstResponder == self && NSGraphicsContext.currentContextDrawingToScreen
    NSGraphicsContext.saveGraphicsState
    NSSetFocusRingStyle(NSFocusRingOnly)
    NSBezierPath.fillRect(bounds)
    NSGraphicsContext.restoreGraphicsState
  end


  ### First responder

  def acceptsFirstResponder
    NSLog("Accepting")
    true
  end

  def resignFirstResponder
    NSLog("Resigning")
    setKeyboardFocusRingNeedsDisplayInRect(bounds)
    true
  end

  def becomeFirstResponder
    NSLog("Becoming")
    setNeedsDisplay true
    true
  end


  ### Keyboard events

  def keyDown(event)
    interpretKeyEvents [event]
  end

  def insertText(input)
    self.string = input
  end

  def insertTab(sender)
    window.selectKeyViewFollowingView(self)
  end

  def insertBacktab(sender)
    window.selectKeyViewPrecedingView(self)
  end

  def deleteBackward(sender)
    self.string = " "
  end

end
