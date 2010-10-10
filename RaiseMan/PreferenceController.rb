#
#  PreferenceController.rb
#  RaiseMan
#
#  Created by Caio Chassot on 2010-10-10.
#  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
#

class PreferenceController < NSWindowController
  attr_accessor :colorWell, :checkbox

  def init
    super.initWithWindowNibName("Preferences") or return nil
    self
  end

  def windowDidLoad
    NSLog("Nib file is loaded")
  end

  def changeBackgroundColor(sender)
    NSLog("Color changed #{colorWell.color.description}")
  end

  def changeNewEmptyDoc(sender)
    NSLog("Checkbox changed #{checkbox.state}")
  end
end
