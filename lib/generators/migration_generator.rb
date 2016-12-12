require 'thor'

module Industrious
  module Generators
    class MigrationGenerator < Thor
      include Thor::Actions

      desc 'generate_migrations', 'Generate the migration files'
      method_option :migrations_path, required: true, aliases: '-m'
      def generate_migrations
        migrations_path = options[:migrations_path]
        MigrationsLookup
          .new(migrations_path, self.class.source_root)
          .pending_migrations
          .each do |migration, destination_file_name_with_rb_ext|
            # this to make sure that the migrations have different timestamps
            sleep 1.1
            timestamp = Time.now.strftime('%Y%m%d%H%M%S')
            destination_path = File.join(
              migrations_path,
              "#{timestamp}_#{destination_file_name_with_rb_ext}"
            )

            template(migration, destination_path)
          end
      end

      class MigrationsLookup
        def initialize(migrations_path, generator_path)
          self.migrations_path = migrations_path
          self.generator_path = generator_path
        end

        def pending_migrations
          pending_gem_migrations.to_h
        end

        def self.strip_stamp(string)
          string.split('_', 2).last
        end

        private

        attr_accessor :migrations_path, :generator_path

        # Create a list of all the migrations that the gem has and are missing
        # from the main application. These migration are templates and have
        # extension of `tt` and have names prefixed with numbers such as `1_`,
        # `2_` etc to give them predefined order. This method also strips those
        # out of the templates names for comparison with project migrations
        # and adds `rb` extension.
        def pending_gem_migrations
          Dir[File.join(generator_path, 'templates', '*.tt')].map do |file|
            next nil unless File.file?(file)
            file_name = self.class.strip_stamp(File.basename(file))
            file_name_with_rb_ext = file_name.gsub('.tt', '.rb')
            next nil if existing_migrations.include?(file_name_with_rb_ext)

            [file, file_name_with_rb_ext]
          end.compact
        end

        # Find the existing migrations for the project in the directory
        # that is passed as an argument
        def existing_migrations
          Dir[File.join(migrations_path, '**/*.rb')].map do |file|
            next nil unless File.file?(file)
            self.class.strip_stamp(File.basename(file))
          end.compact
        end
      end

      def self.source_root
        File.dirname(__FILE__)
      end
    end
  end
end
