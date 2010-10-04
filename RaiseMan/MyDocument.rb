#
# MyDocument.rb
# RaiseMan
#
# Created by Caio Chassot on 2010-10-03.
# Copyright __MyCompanyName__ 2010. All rights reserved.
#

class MyDocument < NSDocument
  attr_accessor :employees

  def init
    super
    @employees = []
    self
  end


  ### NSDocument methods (template code)

  # Name of nib containing document window
  def windowNibName
    'MyDocument'
  end

  # Document data representation for saving (return NSData)
  def dataOfType(type, error:outError)
    outError.assign(NSError.errorWithDomain(NSOSStatusErrorDomain, code:-4, userInfo:nil))
    nil
  end

  # Read document from data (return non-nil on success)
  def readFromData(data, ofType:type, error:outError)
    outError.assign(NSError.errorWithDomain(NSOSStatusErrorDomain, code:-4, userInfo:nil))
    nil
  end

  # Return lowercase 'untitled', to comply with HIG
  def displayName
    fileURL ? super : super.sub(/^[[:upper:]]/) {|s| s.downcase}
  end

end
