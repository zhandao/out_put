# frozen_string_literal: true

require 'out_put/version'
require 'out_put/config'
require 'out_put/view'

module OutPut
  def output(code = 0, msg = '', only: nil, http: 200, cache: nil, data: nil, **d, &block)
    data ||= d || { }
    if !code.is_a?(Integer) && code.respond_to?(:info)
      only = code.info[:only]
      code, msg, http, data = code.info.values_at(:code, :msg, :http, :data)
    elsif cache && block_given?
      data, only = _output_cache(cache, data: data, only: only, &block)
    end

    return render json: only.except(:http), status: only[:http] || http if only.present?
    render json: { result: _output_result(code, msg), data: data }, status: http
  end

  alias ok         output
  alias ok_with    output
  alias error      output
  alias error_with output

  def build_with(code = 0, msg = 'success', **data)
    (@view ||= View.new(code, msg)).merge!(data)
    # Then jump to your view
  end

  # ***

  def _output_result(code, msg)
    # code = code.zero? ? 0 : Config.project_code + code
    msg = 'success' if msg.blank? && code.zero?
    msg = "[#{instance_exec(&Config.request_id)}] #{msg}" if Config.request_id && !code.zero?
    { code: code, message: msg }
  end

  def _output_cache(time, data: { }, only: nil, &block)
    cached = Rails.cache.fetch("output/#{action_name}", expires_in: time) do
      instance_eval(&block)
    end

    [ data.merge(cached), cached&.[](:only)&.merge(only || { }) ]
  end
end
