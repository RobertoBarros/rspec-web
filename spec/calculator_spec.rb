# This spec is on for verify the sinatra app.rb behavior
# use like rerun ruby app.rb
require_relative "./calculator"

RSpec.describe Calculator do
  describe "#add" do
    it "returns the sum of two numbers" do
      calculator = Calculator.new
      result = calculator.add(2, 3)
      expect(result).to eq(5)
    end
  end

  describe "#subtract" do
    it "returns the difference between two numbers" do
      calculator = Calculator.new
      result = calculator.subtract(5, 3)
      expect(result).to eq(2)
    end
  end

  describe "#subtract" do
    xit "returns the difference between two numbers" do
      calculator = Calculator.new
      result = calculator.subtract(5, 3)
      expect(result).to eq(2)
    end
  end

end
