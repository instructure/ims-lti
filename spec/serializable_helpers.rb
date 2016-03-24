class FakeSerializable
  def as_json
    {}
  end
end

class FakeListOfSerializables
  def map
    []
  end

  def as_json
    []
  end
end

