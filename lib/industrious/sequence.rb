# frozen_string_literal: true
module Industrious
  class Sequence < ApplicationRecord
    belongs_to :workflow
    belongs_to :from_task, class_name: Task
    belongs_to :to_task, class_name: Task

    validate :cant_link_the_same_task_to_itself

    private

    def cant_link_the_same_task_to_itself
      return unless from_task.present? && to_task.present? && from_task == to_task
      errors.add(:to_task, 'cannot be the same as the task you are linking from')
    end
  end
end
