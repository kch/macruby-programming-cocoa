#
#  Foo.rb
#  RandomApp
#
#  Created by Caio Chassot on 2010-10-03.
#  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
#

class Foo
  attr_accessor :textField

  def seed(sender)
    srand
    textField.setStringValue "Generator seeded"
  end

  def generate(sender)
    textField.setIntValue rand(100).succ
  end

  def awakeFromNib
    textField.setObjectValue Time.now
  end
end
