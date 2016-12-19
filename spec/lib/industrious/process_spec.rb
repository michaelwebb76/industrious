# frozen_string_literal: true
require 'spec_helper'

module Industrious
  describe Process do
    let(:workflow) { Workflow.create(title: 'TEST', description: 'TEST') }
    let(:task) { Task.create(type: 'Industrious::Task', description: 'TEST') }

    describe 'process can be created' do
      subject(:process) do
        described_class.new(workflow: workflow, data_identifier: 123, started: Time.zone.now)
      end

      it { is_expected.to be_valid }
    end

    describe '.start' do
      subject(:start) { described_class.start(workflow, 123) }

      describe 'workflow sequence is valid' do
        before do
          expect(workflow).to receive(:sequence_valid?).and_return(true)
          expect(workflow).to receive(:starting_point_task_id).and_return(task.id)
        end

        specify do
          expect(described_class.count).to eq 0
          expect(State.count).to eq 0
          start
          expect(described_class.count).to eq 1
          expect(State.count).to eq 1
        end
      end

      describe 'workflow sequence is invalid' do
        before { expect(workflow).to receive(:sequence_valid?).and_return(false) }

        specify { expect { start }.to raise_error 'Workflow invalid!' }
      end
    end
  end
end
