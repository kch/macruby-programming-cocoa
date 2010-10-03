#
#  TableViewRowDeletable.rb
#  TaDa
#
#  Created by Caio Chassot on 2010-10-03.
#  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
#

module TableViewRowDeletable
  def keyUp(event)
    return super(event) unless event.characters.include?(NSDeleteCharacter.chr)
    delegate.tableView(self, deleteObjectAtIndex:selectedRow)
  end
end
