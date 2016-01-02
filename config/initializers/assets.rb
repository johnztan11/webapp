# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w( landing.css )
Rails.application.config.assets.precompile += %w( landing.js )

Rails.application.config.assets.precompile += %w( production_requirements.js )
Rails.application.config.assets.precompile += %w( production/form-wizard.js )
Rails.application.config.assets.precompile += %w( production/ui-notifications.js )
# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
