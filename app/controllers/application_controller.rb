class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def render_service_result(result, success_status: :ok)
    if service_success?(result)
      render json: extract_payload(result), status: success_status
    else
      render json: { error: extract_error(result) }, status: :unprocessable_entity
    end
  end

  def service_success?(result)
    return result.success? if result.respond_to?(:success?)

    result.is_a?(Hash) && (result[:success] == true || result['success'] == true)
  end

  def extract_payload(result)
    return result.payload if result.respond_to?(:payload)

    return result[:data] if result.is_a?(Hash) && result.key?(:data)
    return result['data'] if result.is_a?(Hash) && result.key?('data')

    result
  end

  def extract_error(result)
    return result.error if result.respond_to?(:error)

    return result[:error] if result.is_a?(Hash) && result.key?(:error)
    return result['error'] if result.is_a?(Hash) && result.key?('error')

    'Unprocessable entity'
  end
end
