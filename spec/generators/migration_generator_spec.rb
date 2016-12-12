require 'spec_helper'
require 'fileutils'

describe Industrious::Generators::MigrationGenerator do
  subject(:run_generator) { described_class.start(params) }

  describe 'generate_migrations' do
    let(:migration_directory) { File.join(ROOT, 'tmp/migrations') }
    let(:params) { ['generate_migrations', "--migrations_path=#{migration_directory}"] }

    around do |example|
      FileUtils.rm_rf(migration_directory, secure: true)
      example.run
      FileUtils.rm_rf(migration_directory, secure: true)
    end

    let(:generated_migrations) { Dir[File.join(migration_directory, '*.rb')].sort }

    context 'generated migrations are missing from app' do
      before { run_generator }

      it 'copies all migrations' do
        gem_migrations.each_with_index do |migration, index|
          expect(generated_migrations[index]).to match(/#{migration}/)
        end
      end
    end

    context 'some generated migrations already exist' do
      let(:existing_migration) { "123_#{gem_migrations.first}" }
      let(:existing_migration_path) { File.join(migration_directory, existing_migration) }

      before do
        FileUtils.mkdir_p(migration_directory)
        FileUtils.touch(existing_migration_path)
        run_generator
      end

      it 'copies remaining migrations' do
        gem_migrations.each do |migration|
          expect(generated_migrations).to include(/#{migration}/)
        end
        expect(generated_migrations.count).to eq gem_migrations.count
        expect(File.exist?(existing_migration_path)).to be true
      end
    end
  end

  def gem_migrations
    Dir[File.join(ROOT, 'lib/generators/templates/*.tt')].sort.map do |file|
      file_name = File.basename(file, '.*').split('_', 2).last
      "#{file_name}.rb"
    end
  end
end
