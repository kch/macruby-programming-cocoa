#
#  FirstLetter.rb
#  TypingTutor
#
#  Created by Caio Chassot on 2010-10-12.
#  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
#

module FirstLetter

  def BNR_firstLetter
    self[0, 1]
  end

end

class NSString
  include FirstLetter
end
