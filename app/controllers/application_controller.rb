# Generic application controller
class ApplicationController < ActionController::API
  protected

    # rubocop:disable AbcSize
    def handle_exception
      yield
    rescue Mongoid::Errors::DocumentNotFound => e
      render json: { errors: "#{e.klass} does not exist" }, status: :not_found
    rescue Mongoid::Errors::InvalidFind => e
      render json: { errors: "#{e.klass} cannot be null" }, status: :bad_request
    rescue Mongoid::Errors::Validations => e
      render json: { errors: e.document.errors.full_messages }, status: :bad_request
    rescue Mongoid::Errors::DocumentNotDestroyed => e
      render json: { errors: e.problem }, status: :forbidden
    rescue Mongoid::Errors::MongoidError => e
      logger.error e.problem
      render json: { errors: e.problem }, status: :internal_server_error
    end
end
