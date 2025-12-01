# frozen_string_literal: true

require "view_component/engine"

module ErpAccounts
  class Engine < ::Rails::Engine
    isolate_namespace ErpAccounts
    
    initializer "erp_users.setup" do |app|
      ActiveSupport.on_load(:action_controller_base) do
        append_view_path Rails.root.join("app", "views")
      end
    end

    initializer "erp_users.i18n" do |app|
      config.i18n.load_path += Dir[root.join("config/locales/**/*.{rb,yml}")]
    end

    config.eager_load_paths << root.join("app/components")

    config.generators do |g|
      g.template_engine :slim
      g.view_component true
    end
  end
end
