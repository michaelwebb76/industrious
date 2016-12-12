# Industrious

Industrious is an attempt to address the lack of quality workflow engines available in Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'industrious', git: 'git@github.com:tricycle/industrious.git'
```

And then execute:

    $ bundle install
    $ bundle binstubs industrious

## Usage

There is no configuration needed to use the gem. However there are migrations for
the models that will be copied to the destination project and *should* be added
to the version control of that project.

To generate the migration files, run:

    $ ./bin/industrious generate_migrations -m db/migrate
    $ rake db:migrate

## Note about adding migrations

The migrations are normal rails migration classes but are added as thor template
files that will get copied to the root projects. Their names should be prefixed
with numbers e.g. `1_migration.tt`, `2_another_migration.tt` etc to make sure they
get the right ordering.

The migration generator task will only copy the migrations which are not present in the
root project. Be careful not to modify the existing migrations as it may affect the working of the
gem and its ability to continually update the data model.
