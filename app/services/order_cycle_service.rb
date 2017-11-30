class OrderCycleService
  def self.run
    order_cycles = OrderCycle.where(orders_close_at: 10.days.ago..Time.now)
    order_cycles.each do |order_cycle|
      order_cycle.suppliers.each do | coordinator|
        if coordinator.customers.present?
          Spree::OrderMailer.farmer_report(coordinator, order_cycle).deliver
          coordinator.customers.each do |customer|
            customer.orders.where(created_at: (order_cycle.orders_open_at)..(order_cycle.orders_close_at)).each do |order|
              if order.completed?
                enterprise_name = order.group_by_supplier.keys.join(', ')
                pickup_time = order.order_cycle.pickup_time_for(order.distributor)
                Spree::OrderMailer.customer_report(order, order_cycle).deliver
              end
            end
          end
        end
      end
    end
  end
end
