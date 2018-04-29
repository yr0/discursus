describe Book do
  it_behaves_like 'Sluggable'

  describe '.all_categories' do
    it 'returns all categories of books' do
      books = create_list(:book, 2, :with_categories)
      expect(Book.all_categories.pluck(:name)).to match_array(books.flat_map(&:categories).map(&:name))
    end

    it 'returns empty array if book has no categories' do
      create_list(:book, 2)
      expect(Book.all_categories).to be_empty
    end
  end

  describe '.with_authors' do
    let(:books_with_authors) { create_list(:book, 2, :with_authors, authors_amount: 2) }

    it 'returns author names along with books info' do
      book1, book2 = books_with_authors
      expect(Book.with_authors.map(&:author_names))
        .to match_array([book1.authors.order(:name).pluck(:name), book2.authors.order(:name).pluck(:name)])
    end

    it 'performs a single DB query to get the names' do
      expect do
        Book.with_authors.map(&:author_names)
      end.to make_database_queries(count: 1)
    end

    it 'returns empty array for author names for books that have no authors' do
      books_with_authors
      book = create(:book)
      expect(Book.with_authors.find(book.id).author_names).to eq []
    end
  end

  describe '#author_names' do
    let(:authors) { create_list(:author, 2) }
    let(:book) { create(:book, authors: authors) }
    let(:books_list) { create_list(:book, rand(2..4), :with_authors) }
    let(:another_book) { create(:book) }

    it 'falls back to #pluck if the .with_authors scope was not used' do
      book
      expect(Book.first.author_names).to eq authors.pluck(:name)
    end
  end
end
