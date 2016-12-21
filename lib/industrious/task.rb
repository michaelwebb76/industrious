# frozen_string_literal: true
module Industrious
  class Task < ApplicationRecord
    validates :description, presence: true
    validates :type, presence: true

    def execute
      raise NotImplementedError
    end

    def can_execute?(_)
      raise NotImplementedError
    end
  end
end
