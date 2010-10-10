#
#  AppController.rb
#  RaiseMan
#
#  Created by Caio Chassot on 2010-10-10.
#  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
#

require 'PreferenceController'
class AppController
  attr_accessor :preferenceController

  def self._initialize
    NSUserDefaults.standardUserDefaults.registerDefaults \
      BNRTableBgColorKey => NSKeyedArchiver.archivedDataWithRootObject(NSColor.yellowColor),
      BNREmptyDocKey     => true
  end

  def showPreferencePanel(sender)
    (@preferenceController ||= PreferenceController.new).showWindow(self)
  end

  def applicationShouldOpenUntitledFile(selder)
    NSUserDefaults.standardUserDefaults.boolForKey(BNREmptyDocKey)
  end
end
