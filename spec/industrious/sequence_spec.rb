require 'spec_helper'

module Industrious
  describe Sequence do
    describe 'sequence can be created' do
      subject(:sequence) do
        first_task = Task.new(description: 'TEST 1', type: 'Industrious::Task')
        second_task = Task.new(description: 'TEST 2', type: 'Industrious::Task')
        described_class.new(from_task: first_task, to_task: second_task)
      end

      it { is_expected.to be_valid }
    end

    describe 'validations' do
      context 'sequence from and to tasks are the same' do
        subject(:sequence) do
          task = Task.new(description: 'TEST 1', type: 'Industrious::Task')
          described_class.new(from_task: task, to_task: task)
        end

        it { is_expected.not_to be_valid }
      end
    end
  end
end
