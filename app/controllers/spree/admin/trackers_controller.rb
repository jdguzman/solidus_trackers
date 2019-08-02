class Spree::Admin::TrackersController < Spree::Admin::ResourceController
    def index
        @trackers = Spree::Tracker.where(store_id: spree_user.team.store.id)
    end
end
