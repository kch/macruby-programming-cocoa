#
#  CarArrayController.rb
#  CarLot
#
#  Created by Caio Chassot on 2010-10-10.
#  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
#

class CarArrayController < NSArrayController

  def newObject
    super.tap { |o| o.setValue(Time.now, forKey:"datePurchased") }
  end

end
