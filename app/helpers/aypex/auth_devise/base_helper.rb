module Aypex
  module Auth
    module BaseHelper
      def aypex_svg_tag(file_name, options = {})
        prefixed_file = "aypex/auth/#{file_name}"

        inline_svg_tag(prefixed_file, options)
      end
    end
  end
end
