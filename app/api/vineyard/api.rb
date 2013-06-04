module Vineyard
  class API < Grape::API
    prefix 'api'
    version 'v1', using: :header, vendor: 'vineyard'
    format :json

    helpers do
      def winery
        Winery.find_by_id(params[:id])
      end
    end

    resource :wineries do
      desc "Return all wineries."
      get do
        Winery.all
      end

      desc "Return winery by id."
      params do
        requires :id, type: Integer, desc: "Winery id."
      end
      get ':id' do
        winery
      end

      desc "Create a winery."
      params do
        requires :winery, type: Hash, desc: "Winery params."
      end
      post do
        winery = Winery.new(params[:winery])
        if winery.save
          { status: 'Successfully created' }
        else
          { errors: winery.errors }
        end
      end

      desc "Update a winery."
      params do
        requires :id, type: Integer, desc: "Winery id."
        requires :winery, type: Hash, desc: "Winery params."
      end
      put ':id' do
        winery.update_attributes(params[:winery]) if winery
      end

      desc "Delete a winery."
      params do
        requires :id, type: Integer, desc: "Winery id."
      end
      delete ':id' do
        winery.destroy if winery
      end
    end
  end
end
