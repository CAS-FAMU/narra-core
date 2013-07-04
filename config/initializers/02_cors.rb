# CORS
Rails.application.config.middleware.use Rack::Cors do
  allow do
    origins '*'
    # location of your API
    resource '*', headers: :any, methods: :get
  end
end