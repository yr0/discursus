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

  describe '.with_author_names' do
    let(:books_with_authors) { create_list(:book, 2, :with_authors, authors_amount: 2) }

    def get_author_names(book)
      book.authors.pluck(:name).join(', ')
    end

    it 'returns author names along with books info' do
      book1, book2 = books_with_authors
      expect(Book.with_author_names.map(&:author_names))
        .to match_array([get_author_names(book1), get_author_names(book2)])
    end

    it 'returns book with all other fields intact' do
      books_with_authors
      the_book = Book.with_author_names.first
      expect(the_book.id).to be_present
      expect(the_book.created_at).to be_present
      expect(the_book.title).to be_present
    end

    it 'performs a single DB query to get the names' do
      expect do
        Book.with_author_names.map(&:author_names)
      end.to make_database_queries(count: 1)
    end

    it 'returns empty string for author names for books that have no authors' do
      books_with_authors
      book = create(:book)
      expect(Book.with_author_names.find(book.id).author_names).to eq ''
    end
  end

  describe '#author_names' do
    let(:authors) { create_list(:author, 2) }
    let(:book) { create(:book, authors: authors) }
    let(:books_list) { create_list(:book, rand(2..4), :with_authors) }
    let(:another_book) { create(:book) }

    it 'falls back to #map or #pluck if the .with_author_names scope was not used' do
      book
      expect(Book.first.author_names).to eq authors.pluck(:name).join(', ')
    end

    it 'performs 3 queries (books, author_books, authors) when used as a fallback in collection with :includes' do
      books_list
      expect do
        Book.includes(:authors).map(&:author_names)
      end.to make_database_queries(count: 3)
    end
  end
end
