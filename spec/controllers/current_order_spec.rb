# frozen_string_literal: true

describe ApplicationController, type: :controller do
  context 'with current order' do
    describe '#current_temp_user' do
      it 'returns temp user by cookies uid' do
        temp = create(:temporary_user)
        request.cookies[:temp_user_uuid] = temp.uuid
        expect(controller.current_temp_user).to eq temp
      end
    end

    describe '#current_order' do
      it 'returns first pending order for current signed in user' do
        user = create(:user)
        order = create(:order, customer: user)
        sign_in(user)
        expect(controller.current_order).to eq order
      end

      it 'returns first pending order for current temp user' do
        temp = create(:temporary_user)
        order = create(:order, customer: temp)
        request.cookies[:temp_user_uuid] = temp.uuid
        expect(controller.current_order).to eq order
      end

      it 'does not raise error if no order is present' do
        expect(controller.current_order).to be_nil
      end
    end

    describe '#create_temp_user' do
      it 'sets cookies temp_user_uuid to secure random digest' do
        controller.send(:create_temp_user)
        expect(controller.send(:cookies)[:temp_user_uuid]).to be_present
      end

      it 'returns stored user if they are found in database by uuid' do
        temp = create(:temporary_user)
        request.cookies[:temp_user_uuid] = temp.uuid
        controller.send(:create_temp_user)
        expect(controller.instance_variable_get('@current_temp_user').id).to eq temp.id
      end

      it 'creates temporary user if uuid is not provided in cookies' do
        expect do
          controller.send(:create_temp_user)
        end.to change { TemporaryUser.count }.by 1
      end

      it 'stores saved user uuid in table and in cookies' do
        controller.send(:create_temp_user)
        temp = TemporaryUser.last
        expect(temp.uuid).to be_present
        expect(temp.uuid).to eq controller.send(:cookies)[:temp_user_uuid]
      end

      it 're-creates temp user with another uuid if provided uuid is not found in database' do
        uuid = SecureRandom.hex(8)
        request.cookies[:temp_user_uuid] = uuid
        controller.send(:create_temp_user)
        expect(controller.send(:cookies)[:temp_user_uuid]).not_to eq uuid
      end
    end

    describe '#create_or_get_user_with_order!' do
      it 'creates order for temp user if current user is not present' do
        expect do
          controller.send(:create_or_get_user_with_order!)
        end.to change { TemporaryUser.count }.by 1
        expect(TemporaryUser.last.orders.pending.first).to be_present
      end

      it 'creates order for current user if they are authorized' do
        user = create(:user)
        sign_in(user)
        expect do
          controller.send(:create_or_get_user_with_order!)
        end.to change { user.orders.pending.count }.by 1
      end

      it 'does not create order if authorized user already has pending order' do
        user = create(:user)
        order = create(:order, customer: user)
        sign_in(user)
        expect do
          expect(controller.send(:create_or_get_user_with_order!).id).to eq order.id
        end.to change { user.orders.count }.by 0
      end

      it 'does not create order if temp user already has pending order' do
        user = create(:temporary_user)
        request.cookies[:temp_user_uuid] = user.uuid
        order = create(:order, customer: user)
        expect do
          expect(controller.send(:create_or_get_user_with_order!).id).to eq order.id
        end.to change { user.orders.count }.by 0
      end
    end
  end
end
