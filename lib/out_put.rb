require 'out_put/version'
require 'out_put/config'
require 'out_put/view'

module OutPut
  def output(code = 0, msg = '', only: nil, http: 200, cache: nil, **data, &block)
    if !code.is_a?(Integer) && code.respond_to?(:info)
      code, msg, http, only = code.info.slice(:code, :msg, :http, :only).values
    elsif cache && block_given?
      data, only = _output_cache(cache, data: data, only: only, &block)
    end

    return render json: only, status: http if only.present?

    code = code.zero? ? 0 : Config.project_code + code
    msg = 'success' if msg.blank? && code.zero?
    render json: {
        result: { code: code, message: msg },
        data: _output_data(data)
    }, status: http
  end

  alias ok         output
  alias ok_with    output
  alias error      output
  alias error_with output

  def build_with(code = 0, msg = 'success', **data)
    @view = View.new(code, msg, **data)
    # Then jump to your view
  end

  def _output_data(data)
    if data.key?(Config.pagination_for)
      # TODO now is only for AR
      data.merge!(total: data[Config.pagination_for].try(:unscoped).count)
    end

    data
  end

  def _output_cache(time, data: { }, only: nil, &block)
    cached = Rails.cache.fetch("output/#{action_name}", expires_in: time) do
      instance_eval(&block)
    end

    [ data.merge(cached), only&.merge(cached[:only]) ]
  end
end
