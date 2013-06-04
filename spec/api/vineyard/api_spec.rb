require 'spec_helper'

describe Vineyard::API do
  
  let(:invalid_id) { { "error" => "invalid parameter: id" } }

  describe 'GET api/wineries' do
    context 'no wineries' do
      before { get "/api/wineries" }

      it 'should respond with success' do
        expect(response.status).to eql(200)
      end

      it 'returns an empty array' do
        expect(JSON.parse(response.body)).to be_empty
      end
    end

    it 'returns array with one winery' do
      FactoryGirl.create(:winery)
      get "/api/wineries"
      expect(JSON.parse(response.body).size).to eql(1)
    end
  end

  describe 'GET /api/wineries/:id' do
    let!(:winery) { FactoryGirl.create(:winery) }

    context 'valid params' do
      before { get "/api/wineries/#{winery.id}" }

      it 'should respond with success' do
        expect(response.status).to eql(200)
      end

      it 'returns a winery by id' do
        expect(response.body).to eql(winery.to_json)
      end
    end

    context 'invalid params' do
      before { get '/api/wineries/undefined_id' }

      it 'should respond with Bad Request' do
        expect(response.status).to eql(400)
      end

      it 'should returns an error' do
        expect(JSON.parse(response.body)).to eql(invalid_id)
      end
    end
  end

  describe 'POST /api/wineries' do
    context 'valid params' do
      let(:winery_params) do
        { country: 'Italy',
          tasting_room: true,
          varieties_attributes: [{ name: 'Red Wine' }] }
      end
      let(:success_created) do
        { 'status' => 'Successfully created' }
      end

      before { post '/api/wineries/', winery: winery_params }

      it 'should respond with Created' do
        expect(response.status).to eql(201)
      end

      it 'returns a success created status' do
        expect(JSON.parse(response.body)).to eql(success_created)
      end
    end

    context 'invalid params' do
      context 'no winery params' do
        let(:no_winery_params_error) do
          { "error" => "missing parameter: winery" }
        end

        before { post '/api/wineries' }

        it 'should respond with Bad Request' do
          expect(response.status).to eql(400)
        end

        it 'should returns an error' do
          expect(JSON.parse(response.body)).to eql(no_winery_params_error)
        end
      end

      context 'invalid winery params' do
        let(:invalid_winery_params) do
          { country: nil,
            tasting_room: true,
            varieties_attributes: [{ name: 'Red Wine' }] }
        end

        let(:no_country_error) do
          { "errors" => { "country" => ["can't be blank"] } }
        end

        before { post '/api/wineries', winery: invalid_winery_params }

        it 'should returns an error' do
          expect(JSON.parse(response.body)).to eql(no_country_error)
        end
      end
    end
  end

  describe 'PUT /api/wineries/:id' do
    let!(:winery) { FactoryGirl.create(:winery) }

    context 'valid update params' do
      let(:update_params) { { country: 'USA' } }

      before { put "/api/wineries/#{winery.id}", winery: update_params }

      it 'should respond with success' do
        expect(response.status).to eql(200)
      end

      it 'returns a winery by id' do
        expect(response.body).to be_true
      end
    end

    context 'invalid id' do
      before { put '/api/wineries/undefined_id' }

      it 'should respond with Bad Request' do
        expect(response.status).to eql(400)
      end

      it 'should returns an error' do
        expect(JSON.parse(response.body)).to eql(invalid_id)
      end
    end
  end

  describe 'PUT /api/wineries/:id' do
    let!(:winery) { FactoryGirl.create(:winery) }

    context 'valid update params' do
      before { delete "/api/wineries/#{winery.id}" }

      it 'should respond with success' do
        expect(response.status).to eql(200)
      end

      it 'returns a winery by id' do
        expect(response.body).to be_true
      end
    end

    context 'invalid id' do
      before { delete '/api/wineries/undefined_id' }

      it 'should respond with Bad Request' do
        expect(response.status).to eql(400)
      end

      it 'should returns an error' do
        expect(JSON.parse(response.body)).to eql(invalid_id)
      end
    end
  end
end
