#
#  AppController.rb
#  TypingTutor
#
#  Created by Caio Chassot on 2010-10-13.
#  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
#

class AppController
  MAX_COUNT = 100

  attr_accessor :inLetterView, :outLetterView, :speedSheet, :stepSize, :count

  def initialize
    @letters  = %w[ a s d f j k l ; ]
    @stepSize = 5
    srand
  end

  def awakeFromNib
    showAnotherLetter
  end


  ### Count

  def resetCount
    changingValue("count") { 0 }
  end

  def incrementCount
    changingValue("count") { [count + stepSize, MAX_COUNT].min }
  end

  ### Letters

  def showAnotherLetter
    begin letter = @letters.sample end until letter != @last_letter
    outLetterView.string = @last_letter = letter
    resetCount
  end

  def stopGo(sender)
    if @timer.nil?
      NSLog("Starting")
      @timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector:"checkThem:", userInfo:nil, repeats:true)
    else
      NSLog("Stopping")
      @timer.invalidate
      @timer = nil
    end
  end

  def checkThem(timer)
    showAnotherLetter if inLetterView.string == outLetterView.string
    (count < MAX_COUNT) ? incrementCount : (NSBeep(); resetCount)
  end


  ### Speed sheet

  def showSeedSheet(sender)
    NSApp.beginSheet(speedSheet, modalForWindow:inLetterView.window, modalDelegate:nil, didEndSelector:nil, contextInfo:nil)
  end

  def endSpeedSheet(sender)
    NSApp.endSheet(speedSheet)
    speedSheet.orderOut(sender)
  end


  ### Formatter

  def control(control, didFailToFormatString:s, errorDescription:se)
    NSLog("AppController told that formatting of #{s} failed: #{se}")
    return false
  end


  private

  def changingValue(k)
    willChangeValueForKey(k)
    instance_variable_set("@#{k}",yield(k))
    didChangeValueForKey(k)
  end

end
