module Industrious
  class Task < ApplicationRecord
    validates :description, presence: true
    validates :type, presence: true

    def execute
      raise NotImplementedError
    end
  end
end
