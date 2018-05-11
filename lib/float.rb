class Float

  def to_format
    return self.to_i if self % 1 == 0
    self
  end

end
