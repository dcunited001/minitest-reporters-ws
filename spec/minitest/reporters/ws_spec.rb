require 'spec_helper_integration'

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
  it "skips 1" do
    skip "testing"
  end
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

describe "Err the Tests" do
  it "errors 1" do
    ['Intermitt Ant, the Evil', nil].sample.each_char { |c| c.to_s }
  end
  it "errors 2" do
    UndefDaConstant
  end
  it "errors 3" do
    nil.blah
  end
end
