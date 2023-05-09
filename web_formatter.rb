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
    @compliments = ["You are awesome!", "You have a beautiful soul.", "Your positivity is contagious.", "You're incredibly talented.", "You have a fantastic sense of humor.", "You are so kind and compassionate.", "Your creativity is inspiring.", "You have a wonderful smile.", "Your presence brightens up any room.", "You are a great listener and friend.", "You are a true problem solver.", "Your energy is uplifting.", "You have a unique perspective.", "You're a natural leader.", "You always know the right thing to say.", "Your passion is inspiring.", "You are a ray of sunshine.", "You are wise beyond your years.", "You have an infectious enthusiasm.", "You are truly one of a kind."]
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
