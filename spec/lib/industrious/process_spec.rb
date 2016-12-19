require 'spec_helper'

module Industrious
  describe Process do
    describe 'process can be created' do
      subject(:process) do
        workflow = Workflow.create(title: 'TEST', description: 'TEST')
        described_class.new(workflow: workflow, data_identifier: 123)
      end

      it { is_expected.to be_valid }
    end
  end
end
