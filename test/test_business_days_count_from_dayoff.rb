require File.expand_path('../helper', __FILE__)

describe "business days" do
  describe "with count from dayoff option" do
    describe "when date is on weekend" do
      it "count from dayoff" do
        first = Date.parse("July 1st, 2017")
        later = 1.business_day.before(first, count_from_dayoff: true)
        expected = Date.parse("June 30th, 2017")
        assert_equal expected, later
      end
    end
  end
  describe "without count from dayoff option" do
    describe "when date is on weekend" do
      it "doesn't count from dayoff" do
        first = Date.parse("July 1st, 2017")
        later = 1.business_day.before(first)
        expected = Date.parse("June 29th, 2017")
        assert_equal expected, later
      end
    end
  end
end
