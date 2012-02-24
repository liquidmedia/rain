module Rain
  class Engine < ::Rails::Engine
    engine_name 'rain'

    initializer "rain.assets_precompile" do |app|
      app.config.assets.precompile += Rain.assets
    end

  end
end
