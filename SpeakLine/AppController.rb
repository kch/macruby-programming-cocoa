#
#  AppController.rb
#  SpeakLine
#
#  Created by Caio Chassot on 2010-10-03.
#  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
#

class AppController
  attr_accessor :textField
  attr_accessor :stopButton
  attr_accessor :startButton
  attr_accessor :tableView

  def initialize
    @voices  = NSSpeechSynthesizer.availableVoices
    @speaker = NSSpeechSynthesizer.new
    @speaker.delegate = self
  end

  def awakeFromNib
    ix_defaultVoice = @voices.index NSSpeechSynthesizer.defaultVoice
    tableView.selectRowIndexes(NSIndexSet.indexSetWithIndex(ix_defaultVoice), byExtendingSelection:false)
    tableView.scrollRowToVisible(ix_defaultVoice)
  end


  ### Action methods

  def sayIt(sender)
    return if (s = textField.stringValue).empty?
    @speaker.startSpeakingString(s)
    startButton.enabled = false
    stopButton.enabled  = true
    tableView.enabled   = false
  end

  def stopIt(sender)
    @speaker.stopSpeaking
  end


  ### Delegate methods

  def speechSynthesizer(synth, didFinishSpeaking:complete)
    startButton.enabled = true
    stopButton.enabled  = false
    tableView.enabled   = true
  end

  def tableViewSelectionDidChange(notification)
    @voices[tableView.selectedRow].tap { |v| @speaker.voice = v if v }
  end


  ### TableView datasource methods

  def numberOfRowsInTableView(tableView)
    @voices.count
  end

  def tableView(tableView, objectValueForTableColumn:column, row:rowIndex)
    NSSpeechSynthesizer.attributesForVoice(@voices[rowIndex])[NSVoiceName]
  end

end
