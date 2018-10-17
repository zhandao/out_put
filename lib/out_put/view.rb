module OutPut
  class View < Hash
    attr_accessor :data

    def initialize(code, msg, **data)
      self.data = data
      self.merge!(code: code, msg: msg, **data)
    end
  end
end
