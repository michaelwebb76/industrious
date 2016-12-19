require 'rubygems'
require 'rspec'
require 'pry'
require 'industrious'

ROOT = Pathname(File.expand_path(File.join(File.dirname(__FILE__), '..')))

$LOAD_PATH << File.join(ROOT, 'lib')

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.profile_examples = 10
  config.order = :random
  Kernel.srand config.seed

  config.before(:suite) do
    setup_sqlite_db = lambda do
      ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
      migration_directory = File.join(ROOT, 'tmp/migrations')
      params = ['generate_migrations', "--migrations_path=#{migration_directory}"]
      Industrious::Generators::MigrationGenerator.start(params)
      ActiveRecord::Migrator.up(migration_directory)
    end
    silence_stream(STDOUT, &setup_sqlite_db)
  end

  config.before(:each) do
    Industrious::Task.delete_all
    Industrious::Workflow.delete_all
    Industrious::Sequence.delete_all
    Industrious::Process.delete_all
    Industrious::State.delete_all
    Industrious::StateHistory.delete_all
  end
end
