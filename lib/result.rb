class Result

  attr_reader :r1, :r2

  def initialize( result1, result2 )
    @r1, @r2 = result1.to_i, result2.to_i
  end

  def played?
    @r1 >= 0 and @r2 >= 0
  end

  def ==( o )
    if not played? or not o.played?
      false
    else
      @r1 == o.r1 and @r2 == o.r2
    end
  end

  def eql?( o ) self.to_s.eql?(o.to_s) end

  def hash() self.to_s.hash end

  def <=>( o )
    return 0 if( !self.played? && !o.played? || self == o )
    return 1 if( !self.played? && o.played? )
    return -1 if( self.played? && !o.played? )
    if self.r1 == o.r1
      return self.r2 <=> o.r2
    else
      return self.r1 <=> o.r1
    end
  end

  def diff
    @r1 - @r2
  end

  def to_s
    played? ? "#{@r1}:#{@r2}" : "offen"
  end

end
