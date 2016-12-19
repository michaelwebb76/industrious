module Industrious
  class State < ApplicationRecord
    belongs_to :process
    belongs_to :task
  end
end
