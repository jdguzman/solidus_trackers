class Spree::Tracker < ActiveRecord::Base
  belongs_to :store, class_name: 'Spree::Store', foreign_key: 'store_id'

  validates :store_id, presence: true
  validates :tracker_type, presence: true
  # byebug

  # def self.current(store = nil)
  #   return if !store
  #   if store.is_a?(Spree::Store)
  #     Spree::Tracker.where(active: true, store: store)
  #     # Spree::Tracker.where(active: true, store_id: current_store.id)
  #   else
  #     # TODO: Remove in 2.0
  #     ActiveSupport::Deprecation.warn <<-EOS.squish, caller
  #       Calling Spree::Tracker.current with a string is DEPRECATED. Instead
  #       pass it an instance of Spree::Store.
  #     EOS
  #     Spree::Tracker.where(active: true).joins(:store).where(
  #       "spree_stores.code = ? OR spree_stores.url LIKE ?",
  #       current_store, "%#{store}%"
  #     ).first
  #   end
  # end
  # class << self
  #   deprecate :current, deprecator: Spree::Deprecation
  #   # byebug
  # end
  # def self.active(active = nil)
  #   Spree::Tracker.where(active: active,
  #                       #  store: current_store,
  #                        store_id: store.id,
  #                        tracker_type: type).first
  # end

  def self.current_store
    Spree::Tracker.where(active: true,
                        #  store: current_store,
                         store_id: store.id,
                         tracker_type: type).first
  end

  def self.by_type(store = current_store, type = 'google_analytics')
    # byebug
    Spree::Tracker.where(active: true,
                        #  store: current_store,
                         store_id: store.id,
                         tracker_type: type).first
  end
end
