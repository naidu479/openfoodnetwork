class FarmersMarketSubscriber < ActiveRecord::Base
  belongs_to :enterprise
  attr_accessible :email, :enterprise_id
end
