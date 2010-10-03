#!/usr/bin/env macruby
# encoding: UTF-8
framework "Foundation"

class LotteryEntry
  attr :entryDate, :firstNumber, :secondNumber

  def initialize(date = Time.now)
    @entryDate    = date
    @firstNumber  = rand(100).succ
    @secondNumber = rand(100).succ
  end

  def description
    "#{entryDate.strftime("%b %d %Y")} = #{firstNumber} and #{secondNumber}"
  end
  alias_method :to_s, :description
end

srand
NOW             = Time.now
WEEK_IN_SECONDS = 7 * 24 * 60 * 60
lottery_entries = 10.times.map { |i| i * WEEK_IN_SECONDS }.map { |iw| LotteryEntry.new(NOW + iw) }

lottery_entries.each { |e| NSLog("%@", e) }
