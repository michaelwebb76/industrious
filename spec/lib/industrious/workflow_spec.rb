# frozen_string_literal: true
require 'spec_helper'

module Industrious
  describe Workflow do
    subject(:workflow) do
      described_class.new(title: 'TEST', description: 'TEST')
    end

    let(:first_task) { Task.create(type: 'Industrious::Task', description: 'First Task') }
    let(:second_task) { Task.create(type: 'Industrious::Task', description: 'Second Task') }
    let(:third_task) { Task.create(type: 'Industrious::Task', description: 'Third Task') }

    describe 'workflow can be created' do
      it { is_expected.to be_valid }
    end

    describe '#sequence_valid?' do
      subject(:sequence_valid?) { workflow.sequence_valid? }

      before { workflow.save! }

      context 'no sequences' do
        it { is_expected.to be false }
      end

      context 'multiple start points' do
        before do
          Sequence.create!(workflow: workflow, from_task: first_task, to_task: second_task)
          Sequence.create!(workflow: workflow, from_task: third_task, to_task: second_task)
        end

        it { is_expected.to be false }
      end

      context 'single start point' do
        before do
          Sequence.create!(workflow: workflow, from_task: first_task, to_task: second_task)
          Sequence.create!(workflow: workflow, from_task: second_task, to_task: third_task)
        end

        it { is_expected.to be true }
      end
    end

    describe '#sequences_from' do
      subject(:sequences_from) { workflow.sequences_from(first_task) }

      before { workflow.save! }

      context 'no sequences' do
        it { is_expected.to eq [] }
      end

      context 'sequence exists' do
        let(:first_sequence) do
          Sequence.create(workflow: workflow, from_task: first_task, to_task: second_task)
        end

        before do
          first_sequence
          Sequence.create!(workflow: workflow, from_task: second_task, to_task: third_task)
        end

        it { is_expected.to eq [first_sequence] }
      end
    end
  end
end
