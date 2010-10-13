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
    @attributes = { NSFontAttributeName            => NSFont.fontWithName("Helvetica", size:75),
                    NSForegroundColorAttributeName => NSColor.redColor, }
    registerForDraggedTypes [NSStringPboardType]
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
    if @highlighted
      NSGradient.alloc.initWithStartingColor(NSColor.whiteColor, endingColor:bgColor).drawInRect(bounds, relativeCenterPosition:NSZeroPoint)
    else
      bgColor.set
      NSBezierPath.fillRect(bounds)
    end
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
    pdfData.writeToFile(sheet.filename, options:0, error:(e = Pointer.new(:object))) and return
    NSAlert.alertWithError(e[0]).runModal
  end

  def pdfData
    dataWithPDFInsideRect(bounds)
  end


  ### Pasteboard

  def writeToPasteboard(pb)
    pb.declareTypes([NSStringPboardType, NSPDFPboardType], owner:self)
    pb.setString(string, forType:NSStringPboardType)
    pb.setData(pdfData, forType:NSPDFPboardType)
  end

  def readFromPasteboard(pb)
    return false unless pb.types.include? NSStringPboardType
    self.string = pb.stringForType(NSStringPboardType).BNR_firstLetter
    return true
  end

  def cut(sender)
    copy(sender)
    self.string = ""
  end

  def copy(sender)
    writeToPasteboard(NSPasteboard.generalPasteboard)
  end

  def paste(sender)
    readFromPasteboard(NSPasteboard.generalPasteboard) or NSBeep()
  end


  ### Drag source

  def draggingSourceOperationMaskForLocal(isLocal)
    NSDragOperationCopy | NSDragOperationDelete
  end

  def mouseDown(event)
    @mouseDownEvent = event
  end

  def mouseDragged(event)
    down, _  = locations =  [@mouseDownEvent, event].map(&:locationInWindow)
    distance = Math.hypot(*[:x, :y].map { |m| locations.map(&m).inject(&:-) })
    return if distance < 3
    return if string.empty?
    size  = string.sizeWithAttributes(@attributes)
    image = NSImage.alloc.initWithSize(size)
    image.lockFocus
    drawStringCenteredIn(NSRect.new(NSZeroPoint, size))
    image.unlockFocus
    NSPasteboard.pasteboardWithName(NSDragPboard).tap { |pb|
      writeToPasteboard(pb)
      dragImage(image,
                at:self.convertPoint(down, fromView:nil).tap { |dp| dp.x -= size.width / 2; dp.y -= size.height / 2 },
            offset:NSSize.new(0, 0),
             event:@mouseDownEvent,
        pasteboard:pb,
            source:self,
         slideBack:true) }
  end

  def draggedImage(image, endedAt:screenPoint, operation:operation)
    return unless operation == NSDragOperationDelete
    self.string = ""
  end


  ### Drag destination

  def draggingEntered(sender)
    NSLog("draggingEntered")
    return NSDragOperationNone if sender.draggingSource == self
    @highlighted = true
    setNeedsDisplay true
    return NSDragOperationCopy
  end

  def draggingUpdated(sender)
    NSLog("Operation mask = #{sender.draggingSourceOperationMask}")
    return NSDragOperationNone if sender.draggingSource == self
    return NSDragOperationCopy
  end

  def draggingExited(sender)
    NSLog("draggingExited")
    @highlighted = false
    setNeedsDisplay true
  end

  def prepareForDragOperation(sender)
    true
  end

  def performDragOperation(sender)
    (NSLog("Error: could not read from dragging pasteboard"); return false) unless readFromPasteboard(sender.draggingPasteboard)
    return true
  end

  def concludeDragOperation(sender)
    NSLog("concludeDragOperation")
    @highlighted = false
    setNeedsDisplay true
  end

end
