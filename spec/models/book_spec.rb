describe Book do
  it_behaves_like 'Sluggable'

  context '#author_names' do
    let(:authors) { create_list(:author, 2) }
    let(:book) { create(:book, authors: authors) }
    let(:books_list) { create_list(:book, rand(2..4), :with_authors) }
    let(:another_book) { create(:book) }

    it 'returns names of authors joined by comma' do
      expect(book.author_names).to eq authors.pluck(:name).join(', ')
    end

    it 'does not fail if book has no authors' do
      expect(another_book.author_names).to eq ''
    end

    it 'performs 3 queries (books, author_books, authors) for n books when used in collection with :includes' do
      books_list
      expect do
        Book.includes(:authors).map(&:author_names)
      end.to make_database_queries(count: 3)
    end
  end
end
