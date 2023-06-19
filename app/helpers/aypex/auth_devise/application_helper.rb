module Aypex
  module AuthDevise
    module ApplicationHelper
      def aypex_svg_tag(file_name, options = {})
        prefixed_file = "aypex/auth_devise/#{file_name}"

        inline_svg_tag(prefixed_file, options)
      end
    end
  end
end
