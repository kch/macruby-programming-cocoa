#
# MyDocument.rb
# CarLot
#
# Created by Caio Chassot on 2010-10-10.
# Copyright __MyCompanyName__ 2010. All rights reserved.
#

class MyDocument < NSPersistentDocument

  def windowNibName
    'MyDocument'
  end

  def displayName
    fileURL ? super : super.sub(/^[[:upper:]]/) {|s| s.downcase}
  end

end
