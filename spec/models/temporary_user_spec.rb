describe TemporaryUser do
  context 'callbacks' do
    it 'adds uuid to user after create' do
      expect(create(:temporary_user).uuid).to be
    end
  end
end
