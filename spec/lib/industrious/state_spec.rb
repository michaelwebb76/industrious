require 'spec_helper'

module Industrious
  describe State do
    describe 'state can be created' do
      subject(:state) do
        workflow = Workflow.create(title: 'TEST', description: 'TEST')
        process = Process.create(workflow: workflow, data_identifier: 123)
        task = Task.create(type: 'Industrious::Task', description: 'TEST')
        described_class.new(process: process, task: task)
      end

      it { is_expected.to be_valid }
    end
  end
end
