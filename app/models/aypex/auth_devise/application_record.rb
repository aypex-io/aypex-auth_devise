module Aypex
  module AuthDevise
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
