module Aypex
  module Auth
    module Base
      extend ActiveSupport::Concern
      included do
        helper "aypex/base" if defined?(Aypex::BaseHelper)
        helper "aypex/auth/base"

        include Aypex::ControllerHelpers::Auth if defined?(Aypex::ControllerHelpers::Auth)
        include Aypex::ControllerHelpers::Order if defined?(Aypex::ControllerHelpers::Order)
        include Aypex::ControllerHelpers::Store if defined?(Aypex::ControllerHelpers::Store)
        include Aypex::ControllerHelpers::Currency if defined?(Aypex::ControllerHelpers::Currency)
        include Aypex::ControllerHelpers::Locale if defined?(Aypex::ControllerHelpers::Locale)
        include AypexI18n::ControllerLocaleHelper if defined?(AypexI18n::ControllerLocaleHelper)
        include Aypex::LocaleUrls if defined?(Aypex::LocaleUrls)

        helper "aypex/locale" if defined?(Aypex::LocaleHelper)
        helper "aypex/currency" if defined?(Aypex::CurrencyHelper)
        helper "aypex/store" if defined?(Aypex::StoreHelper)

        helper_method :title, :title=, :accurate_title

        before_action :set_current_order, except: :show

        layout Aypex::Auth::Config.auth_layout_path

        # We have to override this method providing nil to router name
        # Strange behavior with Rails Engines and router_name.
        def signed_in_root_path(resource_or_scope)
          scope = Devise::Mapping.find_scope!(resource_or_scope)
          router_name = nil # Devise.mappings[scope].router_name
          home_path = "#{scope}_root_path"

          context = router_name ? send(router_name) : self

          if context.respond_to?(home_path, true)
            context.send(home_path)
          elsif context.respond_to?(:root_path)
            context.root_path
          elsif respond_to?(:root_path)
            root_path
          else
            "/"
          end
        end

        protected

        # can be used in views as well as controllers.
        # e.g. <% self.title = 'This is a custom title for this view' %>
        attr_writer :title

        def title
          title_string = @title.present? ? @title : accurate_title
          if title_string.present?
            title_string
          else
            default_title
          end
        end

        def default_title
          current_store.name
        end

        def accurate_title
          current_store.seo_title
        end

        def resource_params
          resource_params = params.fetch(resource_name, {})
          resource_params[:store_id] = current_store.id

          resource_params
        end
      end
    end
  end
end
