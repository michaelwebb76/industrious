# frozen_string_literal: true
module Industrious
  class Worker
    attr_reader :work_done

    def initialize(process)
      self.process = process
    end

    def work
      prior_states = states.dup
      prior_states.each do |state|
        executed = state.task.execute
        next unless executed
        progress_process_from(state)
        self.work_done = true
      end
      work_done
    end

    private

    attr_accessor :process
    attr_writer :work_done

    delegate :states, :workflow, to: :process

    def progress_process_from(state)
      task = state.task
      StateHistory.create!(process: process,
                           task: task,
                           started: state.created_at,
                           finished: Time.zone.now)
      update_process_state(task)
      state.destroy!
    end

    def update_process_state(task)
      next_sequences = workflow.sequences_from(task)
      next_sequences.each do |sequence|
        states.create!(process: process, task_id: sequence.to_task_id)
      end
      process.update_attributes(finished: Time.zone.now) if next_sequences.empty?
    end
  end
end
