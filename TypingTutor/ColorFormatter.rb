#
#  ColorFormatter.rb
#  TypingTutor
#
#  Created by Caio Chassot on 2010-10-15.
#  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
#

class ColorFormatter < NSFormatter

  def init
    super
    @colorList = NSColorList.colorListNamed("Apple")
    self
  end

  def firstColorKeyForPartialString(s)
    return if s.empty?
    @colorList.allKeys.find { |k| k.downcase.start_with? s.downcase }
  end

  def stringForObjectValue(c)
    return unless c.is_a? NSColor
    rgb0 = rgbFromColor(c.colorUsingColorSpaceName(NSCalibratedRGBColorSpace))
    @colorList.allKeys.sort_by { |key| rgb0.zip(rgbFromColor(@colorList.colorWithKey(key))).map { |i, f| (i-f)**2 }.inject(&:+) }.first
  end

  def getObjectValue(p, forString:s, errorDescription:p_errorString)
    if k = firstColorKeyForPartialString(s)
      p.assign @colorList.colorWithKey(k)
    elsif !p_errorString.nil?
      p_errorString.assign "'#{s}' is not a color"
    end
    return !!k
  end

  def isPartialStringValid(s, newEditingString:p_newString, errorDescription:p_errorString)
    return true if s.empty?
    return true if firstColorKeyForPartialString(s)
    p_errorString.assign "No such color"
    return false
  end


  private

  def rgbFromColor(color)
    3.times.map { Pointer.new(?d) }.tap { |r, g, b| color.getRed(r, green:g, blue:b, alpha:nil) }.map { |p| p[0] }
  end

end
