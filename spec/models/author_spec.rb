describe Author do
  it_behaves_like 'Sluggable', :name

  describe 'named_like scope' do
    let(:searched_fragment) { 'Dsc Someone' }

    it 'returns only authors with given name' do
      authors = create_list(:author, 2, name: searched_fragment.upcase)
      create_list(:author, 2)
      expect(Author.named_like(searched_fragment).pluck(:id)).to eq authors.pluck(:id)
    end
  end

  describe '#last_book_titles' do
    let(:author) { create(:author) }
    let(:another_author) { create(:author) }
    let(:authors_list) { create_list(:author, rand(2..4), :with_books) }
    let(:author_books) { Array.new(5) { |n| create(:book, authors: [author], created_at: n.days.since) } }

    it 'returns last book titles of author joined by comma' do
      author_books
      expect(author.last_book_titles).to eq author_books.pluck(:title)[0..2].join(', ')
    end

    it 'does not fail if author has no books' do
      expect(another_author.last_book_titles).to eq ''
    end

    it 'performs 3 queries (authors, author_books, books) for n authors when used in collection with :includes' do
      authors_list
      expect do
        Author.includes(:books).map(&:last_book_titles)
      end.to make_database_queries(count: 3)
    end
  end
end
