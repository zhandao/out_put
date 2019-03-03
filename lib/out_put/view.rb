# frozen_string_literal: true

module OutPut
  class View < Hash
    def initialize(code, msg)
      self.merge!(code: code, msg: msg)
    end
  end
end
