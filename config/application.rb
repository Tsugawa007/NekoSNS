require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NekoSns
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    
    # 日本語にするやつ
    config.i18n.default_locale = :ja

    # タイムゾーンを日本時間に設定
    config.time_zone = 'Asia/Tokyo'
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    
    #neko_apiクラスを実行する為のコード
    config.paths.add 'lib', eager_load: true 
  end
end
