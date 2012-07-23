require 'spec_helper'

describe "Object" do
  before do
    @it = "23"
  end

  describe "Nested describe" do
    it "should read @it" do
      @it.to_i.must_equal 23
    end

    it "should read @it again" do
      @it.to_f.must_equal 23.0
    end
  end
end
