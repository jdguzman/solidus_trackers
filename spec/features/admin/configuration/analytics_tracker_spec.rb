require 'spec_helper'

describe "Analytics Tracker", type: :feature do
  stub_authorization!
  let!(:store1) { create(:store) }
  let!(:tracker1) { create(:tracker, store: store1) }
  let!(:store2) { create(:store) }
  let!(:tracker2) { create(:tracker, store: store2) }

  context "index" do
    before(:each) do
      # 2.times { create(:tracker, store: store) }
      visit spree.admin_path
      click_link "Settings"
      click_link "Stores"
      click_link "Analytics Tracker"
    end

    it "should have the right content" do
      expect(page).to have_content("Analytics Trackers")
    end

    it "should have the right tabular values displayed for the current store" do
      within_row(1) do
        expect(column_text(1)).to eq(tracker1.analytics_id)
        expect(column_text(2)).to eq(tracker1.tracker_type)
        expect(column_text(3)).to eq(tracker1.active)
        # expect(column_text(1)).to eq("A100")
        # expect(column_text(2)).to eq("Google Analytics")
        # expect(column_text(3)).to eq("Active")
      end

    it "should not have the tabular values displayed for the other store" do
      within_row(1) do
        expect(column_text(1)).to_not eq(tracker2.analytics_id)
        expect(column_text(2)).to_not eq(tracker2.tracker_type)
        expect(column_text(3)).to_not eq(tracker2.active)
      end

      # within_row(2) do
      #   expect(column_text(1)).to eq("A100")
      #   expect(column_text(2)).to eq("Google Analytics")
      #   expect(column_text(3)).to eq("Active")
      # end
    end
  end

  context "create" do
    before(:each) do
      visit spree.admin_path
      click_link "Settings"
      click_link "Stores"
      click_link "Analytics Tracker"
    end

    it "should be able to create a new analytics tracker" do
      click_link "admin_new_tracker_link"
      fill_in "tracker_analytics_id", with: "A100"
      select all("#tracker_tracker_type option")[1].text, from: "tracker_tracker_type"
      select all("#tracker_store_id option")[1].text, from: "tracker_store_id"
      click_button "Create"

      expect(page).to have_content("successfully created!")
      within_row(1) do
        expect(column_text(1)).to eq("A100")
        expect(column_text(2)).to eq("Google Analytics")
        expect(column_text(3)).to eq("Active")
      end
    end
  end

  context "store" do
    it "should display the script tag if a tracking id is provided" do
      # create(:tracker, store: store)
      let!(:store1) { create(:store) }
      let!(:tracker1) { create(:tracker, store: store1) }
      let!(:store2) { create(:store) }
      let!(:tracker2) { create(:tracker, store: store2) }

      visit spree.root_path
      expect(page).to have_css('#solidus_trackers_google_analytics', visible: false)
    end
  end
end
