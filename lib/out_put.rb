require 'out_put/version'
require 'out_put/config'

module OutPut
  def output(code = 0, msg = '', only: nil, http: 200, **data)
    if !code.is_a?(Integer) && code.respond_to?(:info)
      code, msg, only, http = code.info.slice(:code, :msg, :only, :http).values
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

ActionController::API.include OutPut

__END__

curl -s https://www.iana.org/assignments/http-status-codes/http-status-codes-1.csv | \
  ruby -ne 'm = /^(\d{3}),(?!Unassigned|\(Unused\))([^,]+)/.match($_) and \
    puts "#{m[1]} => \x27#{m[2].strip}\x27,"'

100 => 'Continue',
101 => 'Switching Protocols',
102 => 'Processing',
103 => 'Early Hints',
200 => 'OK',
201 => 'Created',
202 => 'Accepted',
203 => 'Non-Authoritative Information',
204 => 'No Content',
205 => 'Reset Content',
206 => 'Partial Content',
207 => 'Multi-Status',
208 => 'Already Reported',
226 => 'IM Used',
300 => 'Multiple Choices',
301 => 'Moved Permanently',
302 => 'Found',
303 => 'See Other',
304 => 'Not Modified',
305 => 'Use Proxy',
307 => 'Temporary Redirect',
308 => 'Permanent Redirect',
400 => 'Bad Request',
401 => 'Unauthorized',
402 => 'Payment Required',
403 => 'Forbidden',
404 => 'Not Found',
405 => 'Method Not Allowed',
406 => 'Not Acceptable',
407 => 'Proxy Authentication Required',
408 => 'Request Timeout',
409 => 'Conflict',
410 => 'Gone',
411 => 'Length Required',
412 => 'Precondition Failed',
413 => 'Payload Too Large',
414 => 'URI Too Long',
415 => 'Unsupported Media Type',
416 => 'Range Not Satisfiable',
417 => 'Expectation Failed',
421 => 'Misdirected Request',
422 => 'Unprocessable Entity',
423 => 'Locked',
424 => 'Failed Dependency',
426 => 'Upgrade Required',
428 => 'Precondition Required',
429 => 'Too Many Requests',
431 => 'Request Header Fields Too Large',
451 => 'Unavailable For Legal Reasons',
500 => 'Internal Server Error',
501 => 'Not Implemented',
502 => 'Bad Gateway',
503 => 'Service Unavailable',
504 => 'Gateway Timeout',
505 => 'HTTP Version Not Supported',
506 => 'Variant Also Negotiates',
507 => 'Insufficient Storage',
508 => 'Loop Detected',
510 => 'Not Extended',
511 => 'Network Authentication Required',
