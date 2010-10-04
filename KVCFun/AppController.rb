#
#  AppController.rb
#  KVCFun
#
#  Created by Caio Chassot on 2010-10-03.
#  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
#

class AppController
  attr_accessor :fido

  def initialize
    self.fido = 5
  end

  def incrementFido(sender)
    self.fido += 1
    NSLog("fido is now %d", @fido)
  end

  def setFido(n)
    @fido = Integer(n)
  end

end
