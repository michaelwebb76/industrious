# frozen_string_literal: true
module Industrious
  class ParallelSplitTask < Task
    def can_execute?(_)
      true
    end
  end
end
