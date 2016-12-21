# frozen_string_literal: true
module Industrious
  class SequenceTask < Task
    def can_execute?(_)
      true
    end
  end
end
