# rubocop_html_formatter.rb
require 'rubocop'
require 'erb'

module RuboCop
  module Formatter
    class HTMLFormatter < BaseFormatter

      TEMPLATE = File.read("#{File.dirname(__FILE__)}/template_rubocop.html.erb")

      def initialize(output, options = {})
        super
        @files = []
        @offenses = []
        @summary = Summary.new(offense_count: 0)
      end

      def started(target_files)
        summary.target_files = target_files
      end

      def file_finished(file, offenses)
        @offenses.concat(offenses.map { |offense| { file:, offense: } })
      end

      def finished(inspected_files)
        erb = ERB.new(TEMPLATE, trim_mode: '-')
        html = erb.result(binding)

        output.write html
      end
    end
  end
end
