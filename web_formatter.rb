require 'rspec'
require 'rspec/core/formatters/base_formatter'
require 'erb'
require 'irb'

class WebFormatter < RSpec::Core::Formatters::BaseFormatter
  include ERB::Util

  RSpec::Core::Formatters.register self, :dump_summary, :close

  TEMPLATE = File.read("#{File.dirname(__FILE__)}/template.html.erb")

  def dump_summary(summary)
    @summary = summary
    @summary_hash = summary_hash(summary)
    @title = title
  end

  def close(_notification)
    output.puts render
  end

  private

  def render
    ERB.new(TEMPLATE).result(binding)
  end

  def title
    total_examples = @summary.example_count
    failed_examples = @summary.failure_count
    pending_examples = @summary.pending_count
    passed_examples = total_examples - failed_examples - pending_examples

    pending = " - #{pending_examples} pending" if pending_examples.positive?
    "#{passed_examples}/#{total_examples} passed #{pending}"
  end

  def pluralize(count, string)
    "#{count} #{string}#{'s' unless count.to_i == 1}"
  end

  def summary_hash(summary_notification)
    result = {}

    summary_notification.examples.each do |example|
      top_level_description = example.example_group.top_level_description
      result[top_level_description] ||= []
      result[top_level_description] << example
    end

    result
  end
end
