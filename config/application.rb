require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Formidable
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified
    # here. Application configuration should go into files in
    # config/initializers -- all .rb files in that directory are automatically
    # loaded.

    # Set Time.zone default to the specified zone and make Active Record
    # auto-convert to this zone. Run "rake -D time" for a list of tasks for
    # finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and translations from config/locales/*.rb,yml
    # are auto loaded.
    # config.i18n.default_locale = :de


    # Support /app/view .rb classes and /app/templates files.
    #
    # TODO This should be moved to a gem if we want to keep this pattern.
    config.autoload_paths << (Rails.root + 'app/views').to_s
    config.to_prepare do
      ApplicationController.send(:append_view_path, Rails.root.join('app', 'templates'))
    end
  end
end
