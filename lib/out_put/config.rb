# frozen_string_literal: true

module OutPut
  class Config
    cattr_accessor :project_code, default: 0

    cattr_accessor :pagination_for

    cattr_accessor :request_id, default: nil
  end
end
