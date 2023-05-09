require 'rubocop'
require 'erb'

class WebFormatter < RuboCop::Formatter::BaseFormatter
  TEMPLATE = File.read("#{File.dirname(__FILE__)}/template_rubocop.html.erb")

  def initialize(output, options = {})
    super
    @offenses = {}
  end

  def file_finished(file, offenses)
    @offenses[RuboCop::PathUtil.smart_path(file)] = offenses if offenses.any?
  end

  def finished(inspected_files)
    erb = ERB.new(TEMPLATE, trim_mode: '-')
    html = erb.result(binding)

    output.write html
  end

  def pluralize(count, string)
    "#{count} #{string}#{'s' unless count.to_i == 1}"
  end
end
