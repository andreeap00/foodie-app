module Api
  module V1
    class ApplicationController < ActionController::API
      include Authentication
    end
  end
end
