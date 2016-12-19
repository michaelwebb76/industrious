# frozen_string_literal: true
module Industrious
  class Process < ApplicationRecord
    belongs_to :workflow

    has_many :states, autosave: true, dependent: :destroy
    has_many :state_histories, dependent: :destroy

    validates :data_identifier, presence: true, uniqueness: { scope: :workflow_id }
    validates :started, presence: true

    def self.start(workflow, data_identifier)
      raise 'Workflow invalid!' unless workflow.sequence_valid?
      process = create!(workflow: workflow, data_identifier: data_identifier,
                        started: Time.zone.now)
      State.create!(process: process, task: Task.find(workflow.starting_point_task_id))
      process
    end

    def work
      current_states = states.includes(:task)
      current_states.each { |state| state.task.execute(process) }
    end
  end
end
