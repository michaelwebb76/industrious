module Industrious
  class Process < ApplicationRecord
    belongs_to :workflow

    validates :data_identifier, presence: true, uniqueness: { scope: :workflow_id }

    def self.start(workflow, data_identifier)
      raise 'Workflow invalid!' unless workflow.sequence_valid?
      process = create!(workflow: workflow, data_identifier: data_identifier)
      State.create!(process: process, task: Task.find(workflow.starting_point_task_id))
    end
  end
end
