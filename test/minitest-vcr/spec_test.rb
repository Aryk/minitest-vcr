require "helper"

MinitestVcr::Spec.configure!

describe MinitestVcr::Spec do

  describe 'a describe with metadata', :vcr do
    describe 'with a nested example group' do
      before do
        conn = Faraday.new
        @response = conn.get 'http://example.com'
      end
      it 'uses a cassette for any examples' do
        (VCR.current_cassette.name.split('/')).must_equal([
          'MinitestVcr::Spec',
          'a describe with metadata',
          'with a nested example group',
          'uses a cassette for any examples'
        ])
      end
    end
  end

  describe 'an it with metadata' do
    describe 'with a nested example group' do
      before do
        conn = Faraday.new
        @response = conn.get 'http://example.com'
      end
      it 'uses a cassette for any examples', :vcr do
        (VCR.current_cassette.name.split('/')).must_equal([
          'MinitestVcr::Spec',
          'an it with metadata',
          'with a nested example group',
          'uses a cassette for any examples'
        ])
      end
      it 'can supply metadata', vcr: {record: :all} do
        VCR.current_cassette.record_mode.must_equal :all
      end
    end
  end

  describe "#configure!", :vcr do

    it "should include setup and teardown module into Minitest::Spec" do
      MinitestVcr::Spec.configure!
      Minitest::Spec.included_modules.must_include(MinitestVcr::Spec::SetupAndTeardown)
    end
  end
end
