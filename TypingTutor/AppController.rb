#
#  AppController.rb
#  TypingTutor
#
#  Created by Caio Chassot on 2010-10-13.
#  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
#

class AppController
  MAX_COUNT  = 100
  COUNT_STEP =   5

  attr_accessor :inLetterView, :outLetterView, :count

  def initialize
    @letters = %w[ a s d f j k l ; ]
    srand
  end

  def awakeFromNib
    showAnotherLetter
  end

  def resetCount
    changingValue("count") { 0 }
  end

  def incrementCount
    changingValue("count") { [count + COUNT_STEP, MAX_COUNT].min }
  end

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


  private

  def changingValue(k)
    willChangeValueForKey(k)
    instance_variable_set("@#{k}",yield(k))
    didChangeValueForKey(k)
  end

end
