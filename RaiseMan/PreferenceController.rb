#
#  PreferenceController.rb
#  RaiseMan
#
#  Created by Caio Chassot on 2010-10-10.
#  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
#

BNRTableBgColorKey          = "TableBackgroundColor"
BNREmptyDocKey              = "EmptyDocumentFlag"
BNRColorChangedNotification = "BNRColorChanged"

class PreferenceController < NSWindowController

  attr_accessor :colorWell, :checkbox

  def init
    super.initWithWindowNibName("Preferences") or return nil
    self
  end

  def windowDidLoad
    colorWell.color = tableBgColor
    checkbox.state  = emptyDoc?
  end

  def changeBackgroundColor(sender)
    color = colorWell.color
    defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(color), forKey:BNRTableBgColorKey)
    NSNotificationCenter.defaultCenter.postNotificationName(BNRColorChangedNotification, object:self, userInfo:{ color:color })
  end

  def changeNewEmptyDoc(sender)
    defaults.setBool(checkbox.state == 1, forKey:BNREmptyDocKey)
  end

  def tableBgColor
    NSKeyedUnarchiver.unarchiveObjectWithData(defaults.objectForKey(BNRTableBgColorKey))
  end

  def emptyDoc?
    defaults.boolForKey(BNREmptyDocKey)
  end

  private

  def defaults
    NSUserDefaults.standardUserDefaults
  end
end
