#
#  BigLetterView.rb
#  TypingTutor
#
#  Created by Caio Chassot on 2010-10-12.
#  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
#

class BigLetterView < NSView
  attr_accessor :string, :bgColor, :attributes

  def initWithFrame(rect)
    super or return nil
    @bgColor    = NSColor.yellowColor
    @string     = " "
    @attributes = {
      NSFontAttributeName            => NSFont.fontWithName("Helvetica", size:75),
      NSForegroundColorAttributeName => NSColor.redColor,
    }
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
    setNeedsDisplay true
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
    drawStringCenteredIn(bounds)
    return unless window.firstResponder == self && NSGraphicsContext.currentContextDrawingToScreen
    NSGraphicsContext.saveGraphicsState
    NSSetFocusRingStyle(NSFocusRingOnly)
    NSBezierPath.fillRect(bounds)
    NSGraphicsContext.restoreGraphicsState
  end

  def drawStringCenteredIn(rect)
    strSize   = string.sizeWithAttributes(@attributes)
    strOrigin = NSPoint.new *[[:x, :width], [:y, :height]].map { |p, l| rect.origin.send(p) + (rect.size.send(l) - strSize.send(l)) / 2 }
    string.drawAtPoint(strOrigin, withAttributes:@attributes)
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


  ### PDF

  def savePDF(sender)
    panel = NSSavePanel.savePanel
    panel.requiredFileType = "pdf"
    panel.beginSheetForDirectory(nil,
                            file:nil,
                  modalForWindow:window,
                   modalDelegate:self,
                  didEndSelector:"didEnd:returnCode:contextInfo:",
                     contextInfo:nil)
  end

  def didEnd(sheet, returnCode:code, contextInfo:_)
    return unless code == NSOKButton
    dataWithPDFInsideRect(bounds).writeToFile(sheet.filename, options:0, error:(e = Pointer.new(:object))) and return
    NSAlert.alertWithError(e[0]).runModal
  end

end
