require 'spec_helper'

module Industrious
  describe Workflow do
    describe 'workflow can be created' do
      subject(:workflow) do
        task = Task.create(description: 'TEST', type: 'Industrious::Task')
        described_class.new(description: 'TEST', initial_task: task)
      end

      it { is_expected.to be_valid }
    end
  end
end
