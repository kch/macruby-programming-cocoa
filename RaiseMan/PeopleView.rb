#
#  PeopleView.rb
#  RaiseMan
#
#  Created by Caio Chassot on 2010-10-20.
#  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
#

class PeopleView < NSView

  def initWithPeople(people)
    initWithFrame(NSRect.new([0, 0], [700, 700]))
    @people     = people.dup
    @attributes = { font:NSFont.fontWithName("Monaco", size:12.0) }
    @lineHeight = @attributes[:font].capHeight * 1.7
    return self
  end


  ### Pagination

  def knowsPageRange(p_range)
    printInfo     = NSPrintOperation.currentOperation.printInfo
    self.frame    = NSRect.new(NSZeroPoint, printInfo.paperSize)
    @pageRect     = printInfo.imageablePageBounds
    @linesPerPage = Integer(@pageRect.size.height / @lineHeight)
    p_range[0]    = NSRange.new(1, @people.length.fdiv(@linesPerPage).ceil)
    return true
  end

  def rectForPage(i)
    @currentPage = i.pred
    return @pageRect
  end


  # Drawing

  def isFlipped
    true
  end

  def drawRect(r)
    nameRect  = NSRect.new [@pageRect.origin.x, @pageRect.origin.y], [200.0, @lineHeight]
    raiseRect = NSRect.new [NSMaxX(nameRect),   @pageRect.origin.y], [100.0, @lineHeight]
    @people.each_with_index.to_a[@currentPage * @linesPerPage, @linesPerPage].each do |person, ix|
      ("%2d %s"  % [ix, person.personName]).drawInRect(nameRect,  withAttributes:@attributes)
      ("%4.1f%%" % [person.expectedRaise ]).drawInRect(raiseRect, withAttributes:@attributes)
      raiseRect.origin.y = nameRect.origin.y += @lineHeight
    end
  end

end
