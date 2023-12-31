module Aypex
  module AuthDevise
    module Base
      extend ActiveSupport::Concern

      included do
        helper "aypex/base" if defined?(Aypex::BaseHelper)
        helper "aypex/auth_devise/application"

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

        layout "aypex/auth_devise/application"

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
