#
#  AppController.rb
#  RaiseMan
#
#  Created by Caio Chassot on 2010-10-10.
#  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
#

class AppController
  attr_accessor :preferenceController

  def showPreferencePanel(sender)
    (@preferenceController ||= PreferenceController.new).showWindow(self)
  end
end
