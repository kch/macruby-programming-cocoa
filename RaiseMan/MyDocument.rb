#
# MyDocument.rb
# RaiseMan
#
# Created by Caio Chassot on 2010-10-03.
# Copyright __MyCompanyName__ 2010. All rights reserved.
#

require 'PreferenceController'

# fake the NSLocalizedString macro in MacRuby
def NSLocalizedString(key)
  NSBundle.mainBundle.localizedStringForKey(key, value:"", table:nil)
end

class MyDocument < NSDocument
  K_UNIMP_ERR = -4
  attr_accessor :employees, :tableView, :employeeController

  def init
    super
    @employees = []
    NSNotificationCenter.defaultCenter.addObserver(self, selector: :"handleColorChange:", name:BNRColorChangedNotification, object:nil)
    self
  end

  def endEditing
    tableView.window.tap { |w| w.makeFirstResponder(w) or return }
    undoManager.instance_eval { (endUndoGrouping; beginUndoGrouping) unless groupingLevel.zero? }
    true
  end

  def createEmployee(sender)
    endEditing or return
    person = employeeController.newObject
    employeeController.addObject(person)
    employeeController.rearrangeObjects
    tableView.editColumn(0, row:employeeController.arrangedObjects.index(person), withEvent:nil, select:true)
  end

  def removeEmployee(sender)
    NSAlert.alertWithMessageText(NSLocalizedString("DELETE"),
                   defaultButton:NSLocalizedString("DELETE"),
                 alternateButton:NSLocalizedString("CANCEL"),
                     otherButton:nil,
       informativeTextWithFormat:(NSLocalizedString("SURE_DELETE") % employeeController.selectedObjects.count))
      .beginSheetModalForWindow(tableView.window,
                  modalDelegate:self,
                 didEndSelector:(:"alertEnded:code:context:"),
                    contextInfo:nil)
  end

  def alertEnded(alert, code:choice, context:_)
    employeeController.remove(nil) if choice == NSAlertDefaultReturn
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
  alias_method :employees=, :setEmployees

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


  ### NSDocument methods

  # Name of nib containing document window
  def windowNibName
    'MyDocument'
  end

  def windowControllerDidLoadNib(controller)
    super
    tableView.backgroundColor = \
      NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults.objectForKey(BNRTableBgColorKey))
  end

  # Document data representation for saving (return NSData)
  def dataOfType(type, error:outError)
    tableView.window.endEditingFor(nil)
    NSKeyedArchiver.archivedDataWithRootObject(employees)
  end

  # Read document from data (return non-nil on success)
  def readFromData(data, ofType:type, error:outError)
    self.employees = NSKeyedUnarchiver.unarchiveObjectWithData(data)
    return true
  rescue
    outError.assign(NSError.errorWithDomain(NSOSStatusErrorDomain, code:K_UNIMP_ERR, userInfo:{ NSLocalizedFailureReasonErrorKey => "The data is corrupted." })) if outError
    return false
  end

  # Return lowercase 'untitled', to comply with HIG
  def displayName
    fileURL ? super : super.sub(/^[[:upper:]]/) {|s| s.downcase}
  end


  ### Handling notifications

  def handleColorChange(notification)
    tableView.setBackgroundColor(notification.userInfo[:color])
  end


  ### Printing

  def printOperationWithSettings(h, error:p_error)
    NSPrintOperation.printOperationWithView(PeopleView.alloc.initWithPeople(employees), printInfo:printInfo)
  end
end
