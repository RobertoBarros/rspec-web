require 'rspec'
require 'erb'
require 'irb'

class WebFormatter
  include ERB::Util

  RSpec::Core::Formatters.register self,
    :dump_failures,
    :dump_pending,
    :dump_summary,
    :close,
    :example_passed,
    :example_failed,
    :example_pending,
    :example_started,
    :example_group_finished

  TEMPLATE = File.read(File.dirname(__FILE__) + "/template.html.erb").freeze

  def initialize(output)
    @passed = []
    @failed = []
    @pending = []

    @output = output
  end

  def example_started(notification)

  end

  def example_group_finished(notification)

  end

  def example_passed(notification)
    @passed << notification
  end

  def example_failed(notification)
    @failed << notification
  end

  def example_pending(notification)
    @pending << notification
  end

  def dump_pending(notification)

  end

  def dump_failures(notification)

  end

  def dump_summary(notification)
    @summary = notification
    @summary_hash = summary_hash(notification)
  end

  def close(notification)
    @output << render
  end

  private

  def render
    @title = title
    ERB.new(TEMPLATE).result(binding)
  end

  def title
    passed_count = @passed.count
    total = @summary.examples.count
    pending_count = @pending.count
    pending = " - #{pending_count} pending" if pending_count.positive?
    "#{passed_count}/#{total} passed #{pending}"
  end

  def pluralize(count, string)
    "#{count} #{string}#{'s' unless count.to_f == 1}"
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
