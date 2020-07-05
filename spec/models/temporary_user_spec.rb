# frozen_string_literal: true

describe TemporaryUser do
  describe 'callbacks' do
    it 'adds uuid to user after create' do
      expect(create(:temporary_user).uuid).to be_present
    end
  end
end
