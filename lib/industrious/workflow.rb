module Industrious
  class Workflow < ApplicationRecord
    validates :title, presence: true, uniqueness: true
    validates :description, presence: true

    has_many :sequences

    def sequence_valid?
      sequences.load
      return false if sequences.length.zero? || !one_start_point?
      true
    end

    def starting_point_task_id
      sequences.load
      start_point_task_ids.first
    end

    def sequences_from(task)
      sequences.load
      sequences.select { |sequence| sequence.from_task_id == task.id }
    end

    private

    def start_point_task_ids
      start_task_ids = sequences.map(&:from_task_id).uniq
      end_task_ids = sequences.map(&:to_task_id).uniq
      (start_task_ids - end_task_ids).uniq
    end

    def one_start_point?
      start_point_task_ids.length == 1
    end
  end
end
