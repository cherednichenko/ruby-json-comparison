require 'rails_helper'

# Integration tests for DiffsController controller
describe V1::DiffsController, type: :controller do

  describe 'POST #left' do
    it "Returns success" do
      request.env['RAW_POST_DATA'] = 'e1wiZGF0YVwiIDogXCJsZWZ0XCIsIFwic3RhdHVzXCIgOiBcImxlZnRcIn0='
      post :left, params: { id: 1, format: :json }, session: nil
      expect(response).to be_success
    end
  end

  describe 'POST #right' do
    it "Returns success" do
      request.env['RAW_POST_DATA'] = 'e1wiZGF0YVwiIDogXCJyaWdodFwiLCBcInN0YXR1c1wiIDogXCJyaWdodFwifQ=='
      post :right, params: { id: 1, format: :json }, session: nil
      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    it "Left or Right aren't provided yet" do
      get :show, params: { id: 10 }, session: nil

      expect(response.body).to eq "{\"jsons_comparison_result\":\"Left or Right aren't provided yet\"}"
    end

    it "Left and Right are equaled" do
      request.env['RAW_POST_DATA'] = 'e1wiZGF0YVwiIDogXCJyaWdodFwiLCBcInN0YXR1c1wiIDogXCJyaWdodFwifQ=='
      post :left, params: { id: 1, format: :json }, session: nil

      request.env['RAW_POST_DATA'] = 'e1wiZGF0YVwiIDogXCJyaWdodFwiLCBcInN0YXR1c1wiIDogXCJyaWdodFwifQ=='
      post :right, params: { id: 1, format: :json }, session: nil

      get :show, params: { id: 1 }, session: nil

      expect(response.body).to eq "{\"jsons_comparison_result\":\"Left and Right are equaled\"}"
    end

    it "Left and Right have different sizes" do
      request.env['RAW_POST_DATA'] = 'e1wiZGF0YVwiIDogXCJyaWdodFwiLCBcInN0YXR1c1wiIDogXCJyaWdodFwifQ=='
      post :left, params: { id: 1, format: :json }, session: nil

      request.env['RAW_POST_DATA'] = 'eyJjYXIiOiJuaXNzYW4ifQ=='
      post :right, params: { id: 1, format: :json }, session: nil

      get :show, params: { id: 1 }, session: nil

      expect(response.body).to eq "{\"jsons_comparison_result\":\"Left and Right have different sizes\"}"
    end

    it "Returns diff result" do
      request.env['RAW_POST_DATA'] = 'eyJjYXIiOiJuaXNzYW4ifQ=='
      post :left, params: { id: 1, format: :json }, session: nil

      request.env['RAW_POST_DATA'] = 'eyJjdXIiOiJuaXNzdW4ifQ=='
      post :right, params: { id: 1, format: :json }, session: nil

      get :show, params: { id: 1 }, session: nil

      expect(response.body).to eq "{\"jsons_comparison_result\":[{\"offset\":3,\"length\":1},{\"offset\":12,\"length\":1}]}"
    end
  end
end
