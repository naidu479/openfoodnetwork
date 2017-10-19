namespace :subscribe do
  desc 'Send a notification for subscribers'
  task weekly: :environment do
    past_week = Time.current.beginning_of_day - 1.week
    enterprise_products = []
    OrderCycle.not_closed.map(&:distributors).flatten.each do |enterprise|
      products = enterprise.active_products_in_order_cycles
        .where('spree_products.created_at > ?', past_week)
      enterprise_products << { enterprise: enterprise, products: products } if products.any?
    end
    FarmersMarketSubscriber.all.group_by { |fms| fms.email }.each do |email, fmss|
      eids = fmss.map(&:enterprise_id)
      eps = enterprise_products.map { |ep| ep if eids.include?(ep[:enterprise].id) }
      SubscriberMailer.weekly(email, eps).deliver if eps.any?
    end
  end
end
