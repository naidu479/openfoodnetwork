class Schedule < ActiveRecord::Base
  has_and_belongs_to_many :order_cycles, join_table: 'order_cycle_schedules'

  attr_accessible :name, :order_cycle_ids

  validates :order_cycles, presence: true

  scope :with_coordinator, lambda { |enterprise| joins(:order_cycles).where('coordinator_id = ?', enterprise.id).select('DISTINCT schedules.*') }

  def current_or_next_order_cycle
    order_cycles.order('orders_close_at ASC').first
  end
end
