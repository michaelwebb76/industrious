# frozen_string_literal: true
require 'spec_helper'

module Industrious
  class ProceedTask < SequenceTask
    def execute
      true
    end
  end

  class ParallelProceedTask < ParallelSplitTask
    def execute
      true
    end
  end

  class FailToExecuteTask < SequenceTask
    def execute
      true
    end
  end

  class CantExecuteYetTask < SequenceTask
    def can_execute?(_)
      false
    end
  end

  describe Worker do
    let(:workflow) { Workflow.create(title: 'TEST', description: 'TEST') }
    let(:start_process) { Process.start(workflow, 123) }
    let(:do_work) do
      count = 0
      while described_class.new(start_process).work
        count += 1
        raise 'Infinite loop likely!' if count > 5
      end
    end

    context 'sequential flow' do
      before do
        first_task = ProceedTask.create(description: 'First Task')
        second_task = ProceedTask.create(description: 'Second Task')
        third_task = ProceedTask.create(description: 'Third Task')
        Sequence.create!(workflow: workflow, from_task: first_task, to_task: second_task)
        Sequence.create!(workflow: workflow, from_task: second_task, to_task: third_task)
      end

      specify do
        start_process
        do_work
        expect(start_process.states.reload).to be_empty
        state_histories = start_process.state_histories.order(:started)
        task_descriptions = state_histories.map { |history| history.task.description }
        expect(task_descriptions).to eq ['First Task', 'Second Task', 'Third Task']
        expect(start_process.reload.finished).not_to be_nil
      end
    end

    context 'parallel split with blocker on one branch' do
      before do
        first_task = ParallelProceedTask.create(description: 'First Task')
        second_task = ProceedTask.create(description: 'Second Task')
        third_task = ProceedTask.create(description: 'Third Task')
        fourth_task = CantExecuteYetTask.create(description: 'Fourth Task')
        Sequence.create!(workflow: workflow, from_task: first_task, to_task: second_task)
        Sequence.create!(workflow: workflow, from_task: second_task, to_task: fourth_task)
        Sequence.create!(workflow: workflow, from_task: first_task, to_task: third_task)
      end

      specify do
        start_process
        do_work
        states = start_process.states.reload
        expect(states.count).to eq 1
        expect(states.first.task.description).to eq 'Fourth Task'
        state_histories = start_process.state_histories.order(:started)
        task_descriptions = state_histories.map { |history| history.task.description }
        expect(task_descriptions).to eq ['First Task', 'Second Task', 'Third Task']
        expect(start_process.reload.finished).to be_nil
      end
    end
  end
end
