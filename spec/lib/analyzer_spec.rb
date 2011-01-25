require 'spec_helper'

describe Analyzer do
  describe "tokens" do
    it "spaces" do
      Analyzer.tokens("hello world").should == %w(hello world)
    end

    it "commas" do
      Analyzer.tokens("red,white,blue").should == %w(red white blue)
    end

    it "commas and spaces" do
      Analyzer.tokens("red, white, blue").should == %w(red white blue)
    end

    it "periods" do
      Analyzer.tokens("Flood plain data.").should == %w(flood plain data)
    end

    it "parentheses" do
      Analyzer.tokens("(CDFA Number 99)").should == %w(cdfa number 99)
    end

    it "integers" do
      Analyzer.tokens("99 barrels of beer").should == %w(99 barrels of beer)
    end

    it "floating point" do
      Analyzer.tokens("The earth is tilted at 23.439 degrees.").should ==
        %w(the earth is tilted at 23.439 degrees)
    end
  end

  describe "tokenize" do
    it "simple example" do
      Analyzer.tokenize(["aerospace defense", "defense systems"]).should ==
        %w(aerospace defense systems)
    end
  end

  describe "unstop" do
    it "example 1" do
      Analyzer.unstop(%w(the big brown fox jumped)).should ==
        %w(big brown fox jumped)
    end

    it "example 2" do
      Analyzer.unstop(%w(the big brown fox and the hairy gorilla)).should ==
        %w(big brown fox hairy gorilla)
    end
  end

  describe "process" do
    it "simple" do
      Analyzer.process(["the aerospace defense", "systems of defense"]).
        should == %w(aerospace defense systems)
    end

    it "complex" do
      Analyzer.process(["The earth has an axial tilt of 23.439 degrees."]).
        should == %w(earth has axial tilt 23.439 degrees)
    end
  end
end
