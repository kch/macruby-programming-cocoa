#
#  AppController.rb
#  SpeakLine
#
#  Created by Caio Chassot on 2010-10-03.
#  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
#

class AppController
  attr_accessor :textField

  def initialize
    @speechSynth = NSSpeechSynthesizer.new
  end

  def sayIt(sender)
    return if (s = textField.stringValue).empty?
    @speechSynth.startSpeakingString(s)
  end

  def stopIt(sender)
    @speechSynth.stopSpeaking
  end
end
