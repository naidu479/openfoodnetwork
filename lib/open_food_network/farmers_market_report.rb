module OpenFoodNetwork
  class FarmerMarketReport
    attr_reader :params, :user
    def initialize(user, params = {})
      @params = params
      @user = user
    end

    def header
      %w(Name Email Website Contact Phone)
    end

    def search
      permissions = OpenFoodNetwork::Permissions.new(user)
      permissions.visible_enterprises
    end

    def enterprises
      search.reorder('id DESC')
    end

    def table
      rows = []

      enterprises.each_with_index do |enterprise, i|
        rows << [enterprise.name,
                enterprise.email,
                enterprise.website,
                enterprise.contact,
                enterprise.phone]
      end
      rows.compact
    end
  end
end
