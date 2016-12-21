# frozen_string_literal: true
require 'spec_helper'

module Industrious
  describe SynchronizationTask do
    describe '#can_execute?' do
      subject(:can_execute?) { third_task.can_execute?(process) }

      let(:workflow) { Workflow.create(title: 'TEST 1', description: 'TEST 1') }
      let(:process) do
        Process.create(workflow: workflow, data_identifier: 123, started: Time.zone.now)
      end
      let(:first_task) { SequenceTask.create(description: 'First Task') }
      let(:second_task) { SequenceTask.create(description: 'Second Task') }
      let(:third_task) { described_class.create(description: 'Third Task') }

      before do
        Sequence.create!(workflow: workflow, from_task: first_task, to_task: third_task)
        Sequence.create!(workflow: workflow, from_task: second_task, to_task: third_task)
      end

      context 'process has not started' do
        it { is_expected.to be false }
      end

      context 'process at two start points' do
        before do
          State.create!(process: process, task: first_task)
          State.create!(process: process, task: second_task)
        end

        it { is_expected.to be false }
      end

      context 'process at one start point, one has progressed to synchronization' do
        before do
          State.create!(process: process, task: first_task)
          State.create!(process: process, task: third_task)
        end

        it { is_expected.to be false }
      end

      context 'two process states at synchronization' do
        before do
          State.create!(process: process, task: third_task)
          State.create!(process: process, task: third_task)
        end

        it { is_expected.to be true }
      end
    end
  end
end
