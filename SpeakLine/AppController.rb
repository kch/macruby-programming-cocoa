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

  def initialize
    @speaker = NSSpeechSynthesizer.new
    @speaker.delegate = self
  end


  ### Action methods

  def sayIt(sender)
    return if (s = textField.stringValue).empty?
    @speaker.startSpeakingString(s)
    startButton.enabled = false
    stopButton.enabled  = true
  end

  def stopIt(sender)
    @speaker.stopSpeaking
  end


  ### Delegate methods

  def speechSynthesizer(synth, didFinishSpeaking:complete)
    startButton.enabled = true
    stopButton.enabled  = false
  end

end
