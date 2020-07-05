# frozen_string_literal: true

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

  describe 'for_index scope' do
    it 'performs the query without errors' do
      authors = create_list(:author, 2, :with_books, books_amount: 2)
      expect(Author.for_index).to match_array authors
    end
  end

  describe '#with_last_book_titles' do
    let(:authors_with_books) { create_list(:author, 2, :with_books, books_amount: 2) }

    def get_book_titles(author)
      author.books.top_recent.limit(3).pluck(:title).join(', ')
    end

    it 'returns book titles along with authors info' do
      author1, author2 = authors_with_books
      expect(Author.with_last_book_titles.map(&:last_book_titles))
        .to match_array([get_book_titles(author1), get_book_titles(author2)])
    end

    it 'returns author with all other fields intact' do
      authors_with_books
      the_author = Author.with_last_book_titles.first
      expect(the_author.id).to be_present
      expect(the_author.created_at).to be_present
      expect(the_author.name).to be_present
    end

    it 'performs a single DB query to get the titles' do
      expect do
        Author.with_last_book_titles.map(&:last_book_titles)
      end.to make_database_queries(count: 1)
    end

    it 'returns empty string for book titles if author has no books yet' do
      authors_with_books
      author = create(:author)
      expect(Author.with_last_book_titles.find(author.id).last_book_titles).to eq ''
    end
  end

  describe '#last_book_titles' do
    let(:author) { create(:author) }
    let(:another_author) { create(:author) }
    let(:authors_list) { create_list(:author, 2, :with_books) }
    let(:author_books) { Array.new(3) { |n| create(:book, authors: [author], created_at: n.days.since) } }

    it 'falls over to method if with_last_book_titles has not been loaded' do
      author_books
      expect(author.last_book_titles.split(', ')).to match_array author_books.pluck(:title).join(', ').split(', ')
    end

    it 'performs 3 queries (authors, author_books, books) for n authors when used in collection with :includes' do
      authors_list
      expect do
        Author.includes(:books).map(&:last_book_titles)
      end.to make_database_queries(count: 3)
    end
  end
end
