class Spree::Admin::TrackersController < Spree::Admin::ResourceController
    before_action :find_tracker, only: [:edit, :update, :destroy]

    def index
      @trackers = Spree::Tracker.where(store_id: current_store.id)
    end

    def show
      @trackers = Spree::Tracker.where(store_id: current_store.id)
    end

    def new
      @tracker = Spree::Tracker.new
    end

    def create
      @tracker = Spree::Tracker.new(tracker_params)

      if @tracker.respond_to?(:store_id=)
        @tracker[:store_id] = current_store.id
      end

      if @tracker.save
        flash[:success] = "Tracker created"
        redirect_to admin_trackers_path
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @tracker.update_attributes(tracker_params)
        flash[:success] = "Tracker updated"
        redirect_to admin_trackers_path
      else
        render :edit
      end
    end

    def destroy
      @tracker.destroy

      flash[:success] = "Tracker '#{@tracker.name}' deleted"

      respond_with(@tracker) do |format|
        format.html { redirect_to admin_trackers_path }
        format.js { render_js_for_destroy }
      end
    end

  private

    def tracker_params
      params.require(:tracker).permit(:analytics_id, :active, :store_id, :tracker_type, :name, :script, :options, :app_id)
    end

    def find_tracker
      @tracker = Spree::Tracker.where(store_id: current_store.id).find(params[:id])
    end
end
