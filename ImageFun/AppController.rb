#
#  AppController.rb
#  ImageFun
#
#  Created by Caio Chassot on 2010-10-10.
#  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
#

class AppController
  attr_accessor :stretchView

  def showOpenPanel(sender)
    NSOpenPanel.openPanel.beginSheetForDirectory(nil,
                                            file:nil,
                                           types:NSImage.imageFileTypes,
                                  modalForWindow:stretchView.window,
                                   modalDelegate:self,
                                  didEndSelector:'openPanelDidEnd:returnCode:contextInfo:',
                                     contextInfo:nil)
  end

  def openPanelDidEnd(openPanel, returnCode:returnCode, contextInfo:_)
    return unless returnCode == NSOKButton
    stretchView.image = NSImage.alloc.initWithContentsOfFile(openPanel.filename)
  end

end
