# frozen_string_literal: true

describe BookSearchQuery do
  changed_attributes = { text_query: 'hello', category_ids: [1], author_ids: [1], order_field: 'title_for_sorting',
                         order_by_desc: { title_for_sorting: 1, main_price: 0, published_at: 0 } }

  context 'instance without search' do
    it 'stores category ids from params hash' do
      raw_category_ids = ['1', '2', '']
      query = BookSearchQuery.new(category_ids: raw_category_ids)
      expect(query.category_ids).to eq [1, 2]
    end

    it 'does not store category ids if search_all_categories is provided' do
      raw_category_ids = ['1', '2', '']
      query = BookSearchQuery.new(category_ids: raw_category_ids, search_all_categories: 1)
      expect(query.category_ids).to eq []
    end

    it 'stores author ids from params hash' do
      raw_author_ids = ['1', '2', '']
      query = BookSearchQuery.new(author_ids: raw_author_ids)
      expect(query.author_ids).to eq [1, 2]
    end

    it 'downcases text query before storing' do
      text_query = 'Hello WORLD'
      query = BookSearchQuery.new(text_query: text_query)
      expect(query.text_query).to eq text_query.downcase
    end

    it 'returns search query as param hash' do
      query = BookSearchQuery.new(changed_attributes)
      expect(query.to_param).to eq(search_query: changed_attributes.deep_stringify_keys)
    end

    describe 'order' do
      it 'sets default values to order fields if they are not provided' do
        query = BookSearchQuery.new
        expect(query.order_by_desc).to eq BookSearchQuery::DEFAULT_ORDER_BY_DESC
        expect(query.order_field).to eq BookSearchQuery::DEFAULT_ORDER_FIELD
      end

      it 'defaults order if provided order field is not allowed' do
        query = BookSearchQuery.new(order_field: 'what')
        expect(query.order_field).to eq BookSearchQuery::DEFAULT_ORDER_FIELD
      end
    end

    describe '#default?' do
      it 'returns true if query has not been changed' do
        expect(BookSearchQuery.new.default?).to eq true
      end

      changed_attributes.each do |field, value|
        it "returns false if #{field} has non-default value" do
          expect(BookSearchQuery.new(field => value).default?).to eq false
        end
      end
    end
  end

  describe 'search', search: true do
    let(:search_fragment) { 'discursus' }
    let(:category) { create(:category) }
    let(:author) { create(:author) }

    describe 'quality' do
      after(:each) do
        Sunspot.commit
        create_list(:book, 2)
        query = BookSearchQuery.new(@hash_query)
        results = query.search.results
        expect(results.size).to eq 1
        expect(results.first.id).to eq @book.id
      end

      it 'searches for books with fragment in title' do
        @book = create(:book, title: "Hello #{search_fragment}!")
        @hash_query = { text_query: search_fragment }
      end

      it 'searches for books with fragment in description' do
        @book = create(:book, description: "Hello #{search_fragment}!")
        @hash_query = { text_query: search_fragment }
      end

      it 'searches for books with fragment in author name' do
        @book = create(:book, authors: [create(:author, name: "The #{search_fragment}")])
        @hash_query = { text_query: search_fragment }
      end

      it 'searches for books with fragment in updated author name' do
        @book = create(:book, :with_authors)
        @book.authors.first.update(name: "The #{search_fragment}")
        @hash_query = { text_query: search_fragment }
      end

      it 'searches for books with fragment in created author name' do
        @book = create(:book)
        @book.authors << create(:author, name: "The #{search_fragment}")
        @hash_query = { text_query: search_fragment }
      end

      it 'searches for books with certain category id' do
        @book = create(:book, categories: [category])
        @hash_query = { category_ids: [category.id] }
      end

      it 'searches for books with certain author id' do
        @book = create(:book, authors: [author])
        @hash_query = { author_ids: [author.id] }
      end
    end

    describe 'ordering' do
      def compose_hash_query(field, order_desc)
        { order_field: field,
          order_by_desc: {
            title_for_sorting: 0, main_price: 0, published_at: 0
          }.merge(field.to_sym => order_desc.nonzero?) }
      end

      def check_search_with(hash_query, books)
        Sunspot.commit
        query = BookSearchQuery.new(hash_query)
        results = query.search.results
        expect(results.size).to eq books.size
        expect(results.map(&:id)).to eq books.map(&:id)
      end

      it 'correctly orders by date of creating in ascending and descending order' do
        books = [1, 2, 3].map do |period|
          create(:book, published_at: period.days.since(1.month.ago))
        end
        check_search_with(compose_hash_query('published_at', 0), books)
        check_search_with(compose_hash_query('published_at', 1), books)
      end

      it 'correctly orders by title in ascending and descending order' do
        books = %w(Alpha Beta Gamma).map do |title|
          create(:book, title: title)
        end
        check_search_with(compose_hash_query('title_for_sorting', 0), books)
        check_search_with(compose_hash_query('title_for_sorting', 1), books)
      end

      it 'correctly orders by book price in ascending and descending order' do
        books = [100, 200, 300].map do |price|
          create(:book, main_price: price)
        end
        check_search_with(compose_hash_query('main_price', 0), books)
        check_search_with(compose_hash_query('main_price', 1), books)
      end
    end
  end
end
