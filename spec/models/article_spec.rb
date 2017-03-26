describe Article do
  it_behaves_like 'Sluggable'

  context 'sunspot_search', search: true do
    let(:search_fragment) { 'discursus' }

    after(:each) do
      Sunspot.commit
      search_results = Article.sunspot_search(query: search_fragment, per_page: @per_page || 8).results
      expect(search_results.size).to eq 1
      expect(search_results.first.id).to eq @article.id
    end

    it 'finds article by text in title' do
      @article = create(:article, title: "article-#{search_fragment}.")
      create(:article) # another one for checking for false positives
    end

    it 'finds article by text in body' do
      @article = create(:article, body: "article body #{search_fragment}.")
      create(:article)
    end

    it 'takes into account per_page parameter' do
      @article = create_list(:article, 2, title: "article-#{search_fragment}.").first
      @per_page = 1
      create(:article)
    end

    it 'returns article that has searched text in title first' do
      @article = create(:article, title: "article-#{search_fragment}.")
      create(:article, body: "article body #{search_fragment}.")
      @per_page = 1
    end
  end
end
