module Industrious
  class Workflow < ApplicationRecord
    validates :description, presence: true

    belongs_to :initial_task, class_name: Task
  end
end
