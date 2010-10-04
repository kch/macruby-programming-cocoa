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

  def startObservingPerson(person)
    %w[ personName expectedRaise ].each { |s| person.addObserver(self, forKeyPath:s, options:NSKeyValueObservingOptionOld, context:nil) }
  end

  def stopObservingPerson(person)
    %w[ personName expectedRaise ].each { |s| person.removeObserver(self, forKeyPath:s) }
  end

  def setEmployees(a)
    return if a == @employees
    @employees.each { |person| stopObservingPerson(person) }
    @employees = a
    @employees.each { |person| startObservingPerson(person) }
  end

  def insertObject(person, inEmployeesAtIndex:ix)
    undoManager.prepareWithInvocationTarget(self).removeObjectFromEmployeesAtIndex(ix)
    undoManager.actionName = "Insert Person" unless undoManager.isUndoing
    startObservingPerson(person)
    employees[ix, 0] = person
  end

  def removeObjectFromEmployeesAtIndex(ix)
    person = employees[ix]
    undoManager.prepareWithInvocationTarget(self).insertObject(person, inEmployeesAtIndex:ix)
    undoManager.actionName = "Delete Person" unless undoManager.isUndoing
    startObservingPerson(person)
    employees.delete_at(ix)
  end

  def changeKeyPath(keyPath, ofObject:object, toValue:newValue)
    object.setValue(newValue, forKeyPath:keyPath)
  end

  def observeValueForKeyPath(keyPath, ofObject:object, change:change, context:context)
    undoManager.prepareWithInvocationTarget(self).changeKeyPath(keyPath, ofObject:object, toValue:change[NSKeyValueChangeOldKey])
    undoManager.actionName = "Edit"
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
