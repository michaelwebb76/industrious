# frozen_string_literal: true
module Industrious
  class Sequence < ApplicationRecord
    belongs_to :workflow
    belongs_to :from_task, class_name: Task
    belongs_to :to_task, class_name: Task

    validate :cant_link_the_same_task_to_itself
    validate :cant_link_multiple_sequences_from_a_sequence_task
    validate :cant_link_multiple_sequences_to_a_sequence_task

    private

    def cant_link_the_same_task_to_itself
      return unless from_task.present? && to_task.present? && from_task == to_task
      errors.add(:to_task, 'cannot be the same as the task you are linking from')
    end

    def cant_link_multiple_sequences_from_a_sequence_task
      if from_task.is_a?(SequenceTask) &&
         Sequence.where(from_task: from_task, workflow: workflow).where.not(id: id).exists?
        errors.add(:from_task, 'cannot have multiple sequences stemming from it')
      end
    end

    def cant_link_multiple_sequences_to_a_sequence_task
      if to_task.is_a?(SequenceTask) &&
         Sequence.where(to_task: to_task, workflow: workflow).where.not(id: id).exists?
        errors.add(:to_task, 'cannot have multiple sequences going to it')
      end
    end
  end
end
