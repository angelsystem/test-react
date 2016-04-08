# Default to production (we'll override in config/environments/development.rb)
Rails.application.config.react.variant = :production

Rails.application.config.react.addons = true

Rails.application.config.react.jsx_transform_options = {
  harmony: true
}
