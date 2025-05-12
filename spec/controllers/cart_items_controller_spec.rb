require 'rails_helper'

RSpec.describe CartItemsController, type: :controller do
  describe 'POST #create' do
    context 'when item is not already in cart' do
      it 'adds a single item to an empty cart' do
        post :create, params: { item_id: 1 }
        expect(session[:cart]).to eq({ '1' => 1 })
      end

      it 'adds multiple unique items to the cart' do
        post :create, params: { item_id: 1 }
        post :create, params: { item_id: 2 }
        expect(session[:cart]).to eq({ '1' => 1, '2' => 1 })
      end
    end

    context 'when item is already in cart' do
      it 'does not duplicate the item in the cart' do
        session[:cart] = { '1' => 1 }
        post :create, params: { item_id: 1 }
        expect(session[:cart]).to eq({ '1' => 1 })
      end
    end
  end

  describe 'PATCH #update' do
    it 'updates an existing item without affecting others' do
      session[:cart] = { '1' => 1, '2' => 1 }
      patch :update, params: { id: 2 }
      expect(session[:cart]).to eq({ '1' => 1, '2' => 1 }) # value remains 1, as per controller logic
    end

    it 'adds a new item if it wasn’t in the cart' do
      session[:cart] = { '1' => 1 }
      patch :update, params: { id: 3 }
      expect(session[:cart]).to eq({ '1' => 1, '3' => 1 })
    end
  end

  describe 'DELETE #destroy' do
    it 'removes only the specified item' do
      session[:cart] = { '1' => 1, '2' => 1, '3' => 1 }
      delete :destroy, params: { id: 2 }
      expect(session[:cart]).to eq({ '1' => 1, '3' => 1 })
    end

    it 'handles deleting an item that does not exist gracefully' do
      session[:cart] = { '1' => 1 }
      delete :destroy, params: { id: 999 }
      expect(session[:cart]).to eq({ '1' => 1 })
    end
  end
end
