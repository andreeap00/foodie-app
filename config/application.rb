require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NewApp
  class Application < Rails::Application
    config.api_only = true
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.autoload_paths << Rails.root.join('lib')
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    # config.assets.precompile += %w[dark_background_image.png]
    config.assets.precompile += %w( application.js)
    
    config.middleware.use ActionDispatch::Session::CookieStore
    config.middleware.use ActionDispatch::RequestId, header: "X-Request-ID"
    config.middleware.use ActionDispatch::RemoteIp
  end
end
