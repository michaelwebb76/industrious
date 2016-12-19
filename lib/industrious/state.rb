# frozen_string_literal: true
module Industrious
  class State < ApplicationRecord
    belongs_to :process
    belongs_to :task
  end
end
