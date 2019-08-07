require 'spec_helper'

describe Spree::Tracker, type: :model do
  let!(:store1) { create(:store) }
  let!(:tracker1) { create(:tracker, store: store1, tracker_type: 'google_manager') }
  let(:store2) { create(:store, code: 'STORE2', url: 'realfakedoors.com') }
  let!(:tracker2) { create(:tracker, store: store2) }

  describe "current store" do
    it "returns the first active tracker for the current store" do
      expect(Spree::Tracker.first).to eq(tracker1)
    end

    it "does not return the first active tracker for the other store" do
      expect(Spree::Tracker.first).to_not eq(tracker2)
    end

    xit "does not return an inactive tracker for the current store" do
      tracker1.update_attribute(:active, false)
      expect(tracker1.current_store).to eq(nil)
    end

    xit "does not return an inactive tracker for the other store" do
      tracker2.update_attribute(:active, false)
      expect(tracker2).to eq(nil)
    end

    it "finds tracker by current store" do
      expect(tracker1.store).to eq(store1)
    end

    it "does not find the tracker by other store" do
      expect(tracker1.store).to_not eq(store2)
    end

    it "finds tracker based on current store's code" do
        expect(store1.code).to eq(tracker1.store.code)
    end

    it "does not find the tracker based on other store's code" do
        expect(store2.code).to_not eq(tracker1.store.code)
    end

    it "finds tracker based on the current store's url" do
        expect(store1.url).to eq(tracker1.store.url)
    end

    it "does not find the tracker based on the other store's url" do
        expect(store2.url).to_not eq(tracker1.store.url)
    end
  end

  describe "by_type" do
    it "returns the first active tracker for the current store" do
      expect(Spree::Tracker.by_type(store1, tracker1.tracker_type)).to eq(tracker1)
    end

    it "does not return the first active tracker for the other store" do
      expect(Spree::Tracker.by_type(store1, tracker1.tracker_type)).to_not eq(tracker2)
    end

    it "does not return an inactive tracker for the current store" do
      tracker1.update_attribute(:active, false)
      expect(Spree::Tracker.by_type(store1, tracker1.tracker_type)).to eq(nil)
    end

    it "does not return an inactive tracker for the other store" do
      tracker2.update_attribute(:active, false)
      expect(Spree::Tracker.by_type(store2, tracker2.tracker_type)).to eq(nil)
    end

    it "finds tracker by the current store" do
      tracker1.update_attribute(:tracker_type, 'google_analytics')
      expect(Spree::Tracker.by_type(store1, tracker1.tracker_type)).to eq(tracker1)
    end

    it "does not find the tracker by the other store" do
      tracker1.update_attribute(:tracker_type, 'google_analytics')
      expect(Spree::Tracker.by_type(store1, tracker1.tracker_type)).to_not eq(tracker2)
    end
  end
end
