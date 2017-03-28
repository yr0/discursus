describe User do
  context 'from omniauth' do
    let(:provider) { 'facebook' }
    let(:uid) { '123456' }
    let(:name) { Faker::Pokemon.name }
    let(:email) { Faker::Internet.email }

    let(:request_data) { OpenStruct.new(provider: provider, uid: uid, info: OpenStruct.new(name: name, email: email)) }
    let(:request_data_without_email) { OpenStruct.new(provider: provider, uid: uid) }

    it 'creates a user from provided data and populates provider fields' do
      user = User.from_omniauth(request_data)
      expect(user).to be_persisted
      expect(user.oauth_provider).to eq provider
      expect(user.oauth_uid).to eq uid
      expect(user.email).to eq email
      expect(user.name).to eq name
    end

    it 'creates user even if email is not provided in oauth hash' do
      user = User.from_omniauth(request_data_without_email)
      expect(user).to be_persisted
      expect(user.oauth_provider).to eq provider
      expect(user.oauth_uid).to eq uid
      expect(user.email).to eq "#{uid}@devnull"
    end

    it 'finds a user by provided data and authorizes them' do
      expect do
        User.from_omniauth(request_data)
      end.to change { User.count }.by 1

      expect do
        user = User.from_omniauth(request_data)
        expect(user).to be_a User
        expect(user).to be_persisted
      end.to change { User.count }.by 0
    end
  end
end
