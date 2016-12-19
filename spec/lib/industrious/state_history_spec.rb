# frozen_string_literal: true
require 'spec_helper'

module Industrious
  describe StateHistory do
    describe 'state history can be created' do
      subject(:state_history) do
        workflow = Workflow.create(title: 'TEST', description: 'TEST')
        process = Process.create(workflow: workflow, data_identifier: 123)
        task = Task.create(type: 'Industrious::Task', description: 'TEST')
        now = Time.zone.now
        described_class.new(process: process, task: task, started: now, finished: now)
      end

      it { is_expected.to be_valid }
    end
  end
end
