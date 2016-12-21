# frozen_string_literal: true
require 'spec_helper'

module Industrious
  describe Sequence do
    let(:workflow) { Workflow.new(title: 'TEST', description: 'TEST') }
    let(:first_task) { SequenceTask.create(description: 'TEST 1') }
    let(:second_task) { SequenceTask.create(description: 'TEST 2') }
    let(:third_task) { SequenceTask.create(description: 'TEST 3') }

    describe 'sequence can be created' do
      subject(:sequence) do
        described_class.new(workflow: workflow, from_task: first_task, to_task: second_task)
      end

      it { is_expected.to be_valid }
    end

    describe 'validations' do
      context 'sequence from and to tasks are the same' do
        subject(:sequence) { described_class.new(from_task: first_task, to_task: first_task) }

        it { is_expected.not_to be_valid }
      end

      context 'from task already has sequence coming from it' do
        before do
          Sequence.create!(workflow: workflow, from_task: first_task, to_task: second_task)
        end

        subject(:sequence) do
          described_class.new(workflow: workflow, from_task: first_task, to_task: third_task)
        end

        it { is_expected.not_to be_valid }
      end

      context 'to task already has sequence going to it' do
        before do
          Sequence.create!(workflow: workflow, from_task: first_task, to_task: second_task)
        end

        subject(:sequence) do
          described_class.new(workflow: workflow, from_task: third_task, to_task: second_task)
        end

        it { is_expected.not_to be_valid }
      end
    end
  end
end
