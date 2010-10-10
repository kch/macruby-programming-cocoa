#
#  Person.rb
#  RaiseMan
#
#  Created by Caio Chassot on 2010-10-03.
#  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
#

class Person
  attr_accessor :personName, :expectedRaise

  def initialize
    @expectedRaise = 5.0
    @personName    = "New Person"
  end

  def initWithCoder(coder)
    @personName    = coder.decodeObjectForKey("personName")
    @expectedRaise = coder.decodeFloatForKey("expectedRaise")
    self
  end

  def encodeWithCoder(coder)
    coder.encodeObject(personName,   forKey:"personName")
    coder.encodeFloat(expectedRaise, forKey:"expectedRaise")
  end

end
