describe UsedTokenJob do
  describe 'perform' do
    let(:download_token) { create(:download_token) }

    it 'updates the token used flag' do
      expect(download_token.is_used?).not_to be_present
      UsedTokenJob.perform_now(download_token.id)
      expect(download_token.reload.is_used?).to be_present
    end

    it 'fails silently if token is not found' do
      expect { UsedTokenJob.perform_now(0) }.not_to raise_error
    end
  end
end
