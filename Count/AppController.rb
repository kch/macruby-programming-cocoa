#
#  AppController.rb
#  Count
#
#  Created by Caio Chassot on 2010-10-03.
#  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
#

class AppController
  attr_accessor :textField, :countLabel

  def count(sender)
    s = textField.stringValue
    l = s.length
    countLabel.stringValue = "'#{s}' has #{l} character#{'s' if l != 1}."
  end

end
