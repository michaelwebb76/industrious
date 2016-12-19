module Industrious
  class Process < ApplicationRecord
    belongs_to :workflow

    validates :data_identifier, presence: true, uniqueness: { scope: :workflow_id }
  end
end
