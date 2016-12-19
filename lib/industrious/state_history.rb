module Industrious
  class StateHistory < ApplicationRecord
    belongs_to :process
    belongs_to :task

    validates :started, presence: true
    validates :finished, presence: true
  end
end
