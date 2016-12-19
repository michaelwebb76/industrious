require 'spec_helper'

module Industrious
  class DoNothingTask < Task
    def execute
      true
    end
  end

  describe Worker do
    let(:workflow) { Workflow.create(title: 'TEST', description: 'TEST') }
    let(:process) { Process.start(workflow, 123) }

    before do
      first_task = Task.create(type: 'Industrious::DoNothingTask', description: 'First Task')
      second_task = Task.create(type: 'Industrious::DoNothingTask', description: 'Second Task')
      third_task = Task.create(type: 'Industrious::DoNothingTask', description: 'Third Task')
      Sequence.create!(workflow: workflow, from_task: first_task, to_task: second_task)
      Sequence.create!(workflow: workflow, from_task: second_task, to_task: third_task)

      count = 0
      while described_class.new(process).work
        count += 1
        raise 'Infinite loop likely!' if count > 5
      end
    end

    specify do
      process
      expect(process.states.reload).to be_empty
      state_histories = process.state_histories.order(:started)
      task_descriptions = state_histories.map { |history| history.task.description }
      expect(task_descriptions).to eq ['First Task', 'Second Task', 'Third Task']
      expect(process.states).to be_empty
      expect(process.reload.finished).not_to be_nil
    end
  end
end
