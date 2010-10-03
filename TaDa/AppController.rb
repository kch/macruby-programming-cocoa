#
#  AppController.rb
#  TaDa
#
#  Created by Caio Chassot on 2010-10-03.
#  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
#

class AppController
  attr_accessor :newItemField, :toDoTableView

  def initialize
    @todos = []
  end

  def awakeFromNib
    class << toDoTableView; include ::TableViewRowDeletable; end
  end

  ### Action methods

  def createNewItem(sender)
    return if (s = newItemField.stringValue.strip).empty?
    @todos << s
    newItemField.stringValue = ""
    toDoTableView.reloadData
  end

  ### TableView datasource

  def numberOfRowsInTableView(tableView)
    @todos.count
  end

  def tableView(tableView, objectValueForTableColumn:column, row:rowIndex)
    @todos[rowIndex]
  end

  ### TableView delegate

  def tableView(tableView, setObjectValue:string, forTableColumn:column, row:rowIndex)
    @todos[rowIndex] = string.strip
    return unless @todos[rowIndex].empty?
    tableView(tableView, deleteObjectAtIndex:rowIndex)
  end

  def tableView(tableView, deleteObjectAtIndex:rowIndex)
    @todos.slice!(rowIndex)
    tableView.reloadData
  end
end
