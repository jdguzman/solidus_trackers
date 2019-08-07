class Spree::Tracker < ActiveRecord::Base
  belongs_to :store, class_name: 'Spree::Store', foreign_key: 'store_id'

  validates :store_id, presence: true
  validates :tracker_type, presence: true
  # byebug

  def self.current(store = nil)
    return if !store
    if store.is_a?(Spree::Store)
      Spree::Tracker.where(active: true, store: tracker.store)
      # Spree::Tracker.where(active: true, store_id: current_store.id)
    else
      # byebug
      # TODO: Remove in 2.0
      ActiveSupport::Deprecation.warn <<-EOS.squish, caller
        Calling Spree::Tracker.current with a string is DEPRECATED. Instead
        pass it an instance of Spree::Store.
      EOS
      Spree::Tracker.where(active: true).joins(:store).where(
        "spree_stores.code = ? OR spree_stores.url LIKE ?",
        current_store, "%#{store}%"
      ).first
    end
  end
  class << self
    deprecate :current, deprecator: Spree::Deprecation
    # byebug
  end
  def self.active(active = true)
    Spree::Tracker.where(active: active,
                        #  store: current_store,
                         store_id: store.id,
                         tracker_type: type).first
  end
  # def self.current(store_key)
  #   Spree::Deprecation.warn "Spree::Store.current is DEPRECATED"
  #   current_store = Store.find_by(code: store_key) || Store.by_url(store_key).first if store_key
  #   current_store || Store.default
  # end

  def self.current_store
    Spree::Tracker.where(active: true,
                         store: store,
                        #  store_id: current_store.id,
                         tracker_type: type).first
  end

  def self.by_type(store = current_store, type = 'google_analytics')
    # byebug
    Spree::Tracker.where(active: true,
                         store: store,
                        #  store_id: current_store.id,
                         tracker_type: type).first
  end
  # byebug
end
