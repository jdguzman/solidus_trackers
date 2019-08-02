# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Trackers Controller', type: :request do

  describe 'GET /admin/trackers' do
    context 'when multiple stores with trackers exist' do
      let!(:admin_user) {
        create(:engine_platform_user, password: 'password')
      }
      let(:team1) { admin_user.team }
      let(:store1) { team1.store }
      let!(:tracker1) { create(:tracker, store: store1) }
      let!(:team2) { create(:team, :with_store) }
      let!(:store2) { team2.store }
      let!(:tracker2) { create(:tracker, store: store2) }

      before do
        sign_in admin_user
        get '/admin/trackers'
      end

      it 'loads trackers for the current store' do
        expect(assigns(:trackers)).to include(tracker1)
      end

      it 'does not load trackers for the other store' do
        expect(assigns(:trackers)).to_not include(tracker2)
      end
    end

  end

  describe 'POST /admin/trackers/new' do
    context 'when multiple stores exist' do
      let!(:admin_user) {
        create(:admin_user, password: 'password')
      }
      let!(:tracker) {
        create(:tracker, store: store1)
      }
      let!(:store1) { create(:store, :with_business_address) }
      let!(:tracker1) {
        create(:tracker, store: store1)
      }

      let!(:store2) { create(:store, :with_business_address) }

      let(:create_params) {
        {
          tracker: tracker_params,
        }
      }
      let(:tracker_params) {
        {
          name: "Tracker",
          tracker_id: tracker.id,
          store_id: store1.id,
        }
      }

      it 'associates the tracker with the current store' do
        sign_in admin_user
        expect {
          post "/admin/trackers", params: create_params
        }.to change {
          Spree::Tracker.count
        }.by(1)
      end
    end

  end

  describe 'PUT /admin/trackers' do
    context 'when the tracker belongs to another store' do
      let!(:admin_user) {
        create(:admin_user, password: 'password')
      }
      let!(:tracker) {
        create(:tracker)
      }
      let(:store1) { create(:store, :with_business_address) }
      let(:store2) { create(:store, :with_business_address) }
      let!(:tracker2) {
        create(:tracker)
      }

      let(:update_params) {
        {
          tracker: tracker_params,
        }
      }

      let(:tracker_params) {
        {
          name: 'Another Tracker',
          tracker_id: tracker2.id,
          store_id: store2.id,
        }
      }

      before do
        sign_in admin_user
        put "/admin/trackers/#{tracker2.id}", params: update_params
      end

      it 'returns a 404 for trackers from the wrong store' do
        expect(response.status).to eq(404)
      end

      it "does not update the other stores' tracker" do
          expect(tracker2.reload.name).to_not eq(tracker)
      end
    end

  end
end
