# frozen_string_literal: true

# Base mailer class for the application that all other mailers inherit from.
# Provides common email functionality and configurations.
class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"
end
