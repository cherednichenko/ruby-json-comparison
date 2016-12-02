require 'rails_helper'

# Unit tests for Diff model
describe V1::Diff, type: :model do
    let(:diff) { V1::Diff.new }

    describe '.jsons_comparison' do
      it "Left or Right aren't provided yet" do
        expect(diff.jsons_comparison).to eq("Left or Right aren't provided yet")
    end

    it "Left and Right are equaled" do
      diff.left = "{\"car\":\"nissan\"}"
      diff.right = "{\"car\":\"nissan\"}"
      diff.save
      expect(diff.jsons_comparison).to eq("Left and Right are equaled")
    end

    it "Left and Right have different sizes" do
      diff.left = "{\"car\":\"nissan\"}"
      diff.right = "{\"car\":\"lexus\"}"
      diff.save
      expect(diff.jsons_comparison).to eq("Left and Right have different sizes")
    end

    it "Returns diff result" do
      diff.left = "{\"car\":\"lexus\"}"
      diff.right = "{\"cur\":\"lexas\"}"
      diff.save
      expect(diff.jsons_comparison).to eq([{:offset=>3, :length=>1}, {:offset=>11, :length=>1}])
    end
  end
end
