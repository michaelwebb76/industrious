module Industrious
  class Task < ApplicationRecord
    validates :description, presence: true
    validates :type, presence: true
  end
end
