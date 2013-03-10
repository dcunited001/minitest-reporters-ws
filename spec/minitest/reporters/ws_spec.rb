require 'spec_helper'

describe "Passing Tests" do
  it "passes 1" do
    1.must_equal 1
  end
  it "passes 2" do
    2.must_equal 2
  end
  it "passes 3" do
    3.must_equal 3
  end
end

describe "Failing Tests" do
  it "fails 1" do
    1.must_equal 3
  end
  it "passes 2" do
    2.must_equal 2
  end
  it "fails 3" do
    3.must_equal 1
  end
end
