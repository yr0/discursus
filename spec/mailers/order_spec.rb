describe OrderMailer, type: :mailer do
  # rubocop:disable Metrics/AbcSize
  def expect_to_match_order_table(order)
    delivery_body = ActionMailer::Base.deliveries.last.body
    expect(delivery_body).to include I18n.t("orders.payment_methods.#{order.payment_method}")
    expect(delivery_body).to include I18n.t("orders.shipping_methods.#{order.shipping_method}")
    expect(delivery_body).to include CGI.escapeHTML(order.city)
    expect(delivery_body).to include CGI.escapeHTML(order.street)
    expect(delivery_body).to include CGI.escapeHTML(order.full_name)
    expect(delivery_body).to include order.phone
    expect(delivery_body).to include order.email
    expect(delivery_body).to include CGI.escapeHTML(order.comment)
    expect(delivery_body).to include order.total.to_f

    expect(order.line_items).not_to be_empty
    order.line_items.each do |item|
      expect(delivery_body).to include CGI.escapeHTML(item.book.author_names)
      expect(delivery_body).to include CGI.escapeHTML(item.book.title)
      expect(delivery_body).to include item.quantity
      expect(delivery_body).to include item.price.to_f
    end
  end
  # rubocop:enable Metrics/AbcSize

  context '#notify_cash' do
    let!(:order) do
      create(:order, :cash, :digital_and_physical, :submitted,
             city: Faker::Lorem.word, street: Faker::Lorem.word,
             shipping_method: :nova_poshta, full_name: Faker::GameOfThrones.character, phone: '89878987',
             email: Faker::Internet.email, comment: Faker::Lorem.sentence)
    end

    it 'enqueues mail for cash order' do
      expect { OrderMailer.notify_cash(order).deliver_later }.to have_enqueued_job.on_queue('mailers')
    end

    it 'sends out email to correct user with correct data' do
      expect do
        perform_enqueued_jobs do
          OrderMailer.notify_cash(order).deliver_later
        end
      end.to change { ActionMailer::Base.deliveries.size }.by(1)
      expect(ActionMailer::Base.deliveries.last.to.first).to eq order.email
      expect(ActionMailer::Base.deliveries.last.subject).to eq I18n.t('mailers.order.subject', id: order.id)
      expect(ActionMailer::Base.deliveries.last.body).to include I18n.t('mailers.order.notify_cash.message')
      expect_to_match_order_table order
    end
  end

  context '#notify_card' do
    let!(:order) do
      create(:order, :card, :paid_for, :digital_and_physical,
             city: Faker::Lorem.word, street: Faker::Lorem.word,
             shipping_method: :nova_poshta, full_name: Faker::GameOfThrones.character, phone: '89878987',
             email: Faker::Internet.email, comment: Faker::Lorem.sentence)
    end

    it 'enqueues mail for card order' do
      expect { OrderMailer.notify_card(order).deliver_later }.to have_enqueued_job.on_queue('mailers')
    end

    it 'sends out email with card order to correct user with correct data' do
      expect do
        perform_enqueued_jobs do
          OrderMailer.notify_card(order).deliver_later
        end
      end.to change { ActionMailer::Base.deliveries.size }.by(1)
      expect(ActionMailer::Base.deliveries.last.to.first).to eq order.email
      expect(ActionMailer::Base.deliveries.last.subject).to eq I18n.t('mailers.order.subject', id: order.id)
      expect(ActionMailer::Base.deliveries.last.body).to include I18n.t('mailers.order.notify_card.message')
      expect(ActionMailer::Base.deliveries.last.body)
        .to include I18n.t('mailers.order.notify_card.message_before_digital')
      expect(ActionMailer::Base.deliveries.last.body)
        .to include I18n.t('mailers.order.notify_card.message_before_details')
      expect_to_match_order_table order
    end
  end

  context '#notify_admin' do
    let!(:order) do
      create(:order, :card, :paid_for, :digital_and_physical,
             city: Faker::Lorem.word, street: Faker::Lorem.word,
             shipping_method: :nova_poshta, full_name: Faker::GameOfThrones.character, phone: '89878987',
             email: Faker::Internet.email, comment: Faker::Lorem.sentence)
    end

    it 'enqueues mail for card order if admin email is present' do
      expect { OrderMailer.notify_admin(order).deliver_later }.to have_enqueued_job.on_queue('mailers')
    end

    it 'does not send message if admin email is not present' do
      Rails.configuration.admin_email = nil
      expect do
        perform_enqueued_jobs do
          OrderMailer.notify_admin(order).deliver_later
        end
      end.to change { ActionMailer::Base.deliveries.size }.by(0)
    end

    it 'sends out email with card order to admin with correct data' do
      expect do
        perform_enqueued_jobs do
          OrderMailer.notify_admin(order).deliver_later
        end
      end.to change { ActionMailer::Base.deliveries.size }.by(1)
      expect(ActionMailer::Base.deliveries.last.to.first).to eq Rails.configuration.admin_email
      expect(ActionMailer::Base.deliveries.last.subject)
        .to eq I18n.t('mailers.order.notify_admin.subject', id: order.id)
      expect(ActionMailer::Base.deliveries.last.body)
        .to include CGI.escapeHTML(I18n.t('mailers.order.notify_admin.message'))
      expect_to_match_order_table order
    end
  end

  context '#digital_books' do
    let!(:order) do
      create(:order, :paid_for, :digital_and_physical)
    end

    it 'enqueues mail for digital books order' do
      expect { OrderMailer.digital_books(order).deliver_later }.to have_enqueued_job.on_queue('mailers')
    end

    it 'sends out email with digital books order to correct user with correct data' do
      expect do
        perform_enqueued_jobs do
          OrderMailer.digital_books(order).deliver_later
        end
      end.to change { ActionMailer::Base.deliveries.size }.by(1)
      expect(ActionMailer::Base.deliveries.last.to.first).to eq order.email
      expect(ActionMailer::Base.deliveries.last.subject)
        .to eq I18n.t('mailers.order.digital_books.subject', id: order.id)
      expect(ActionMailer::Base.deliveries.last.body).to include I18n.t('mailers.order.digital_books.message')

      expect(order.tokens_for_digital_books).not_to be_empty
      order.tokens_for_digital_books.each do |token|
        expect(ActionMailer::Base.deliveries.last.body).to include I18n.t("books.variants.#{token.variant}#")
        expect(ActionMailer::Base.deliveries.last.body).to include CGI.escapeHTML(token.book.title)
        expect(ActionMailer::Base.deliveries.last.body).to include token.code
      end
    end
  end
end
