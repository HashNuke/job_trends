#!/usr/bin/ruby

require 'active_record'
require 'mysql2' # or 'pg' or 'sqlite3'

ActiveRecord::Base.logger = Logger.new(STDERR)

ActiveRecord::Base.establish_connection(
  adapter:  'mysql2',
  database: 'jobs',
  username: 'root',
  password: '',
  host:     'localhost'
)

class StackJob < ActiveRecord::Base
  serialize :locations
end

class GithubJob < ActiveRecord::Base
  serialize :locations
  # disable STI
  self.inheritance_column = :_type_disabled
end