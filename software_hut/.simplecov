#!/usr/bin/env ruby

IGNORED = %w(
  app/controllers/errors_controller.rb
  app/controllers/pages_controller.rb
  app/helpers/forms_helper.rb
)

class RegexFilter < SimpleCov::Filter
  def matches?(source_file)
    File.fnmatch? filter_argument, source_file.filename
  end
end

SimpleCov.start 'rails' do
  add_filter RegexFilter.new "*/application_*.rb"
  add_filter RegexFilter.new "*/app/channels/*.rb"
  add_filter RegexFilter.new "*/app/inputs/*.rb"
end
