# frozen_string_literal: true
require 'industrious/version'
require 'industrious/models'
require 'generators/migration_generator'

module Industrious
  def self.root
    File.expand_path '../..', __FILE__
  end
end
