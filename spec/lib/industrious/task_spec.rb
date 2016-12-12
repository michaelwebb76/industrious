require 'spec_helper'

describe Industrious::Task do
  describe 'task can be created' do
    subject(:task) do
      described_class.new(description: 'TEST', type: 'Industrious::Task')
    end

    it { is_expected.to be_valid }
  end
end
