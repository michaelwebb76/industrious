# frozen_string_literal: true
module Industrious
  class SynchronizationTask < Task
    def can_execute?(process)
      designed_merge_branch_count = Sequence.where(workflow: process.workflow, to_task: self).count
      return false if designed_merge_branch_count.zero?

      actual_merge_branch_count = process.states.where(task: self).count
      designed_merge_branch_count == actual_merge_branch_count
    end

    def execute
      true
    end
  end
end
