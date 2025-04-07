if ENV["OPENAI_ACCESS_TOKEN"].present?
  OpenAI.configure do |config|
    config.access_token = ENV.fetch("OPENAI_ACCESS_TOKEN")
    config.log_errors = true
  end
else
  Rails.logger.warn "OPENAI_ACCESS_TOKEN n'est pas configuré dans les variables d'environnement"
end
