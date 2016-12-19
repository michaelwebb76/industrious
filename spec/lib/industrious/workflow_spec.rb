require 'spec_helper'

module Industrious
  describe Workflow do
    describe 'workflow can be created' do
      subject(:workflow) do
        described_class.new(title: 'TEST', description: 'TEST')
      end

      it { is_expected.to be_valid }
    end
  end
end
