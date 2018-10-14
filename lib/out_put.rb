require 'out_put/version'
require 'out_put/config'

module OutPut
  def output(code = 0, msg = '', only: nil, http: 200, **data)
    if !code.is_a?(Integer) && code.respond_to?(:info)
      code, msg, http, only = code.info.slice(:code, :msg, :http, :only).values
    end

    return render json: only, status: http if only.present?

    code = code.zero? ? 0 : Config.project_code + code
    msg = 'success' if msg.blank? && code.zero?
    render json: {
        result: { code: code, message: msg },
        data: output_data(data)
    }, status: http
  end

  alias ok         output
  alias ok_with    output
  alias error      output
  alias error_with output

  def output_data(data)
    if data.key?(Config.pagination_for)
      data.merge!(total: data[Config.pagination_for].size)
    end

    data
  end
end
