shared_examples_for 'Sluggable' do |sluggable_field = :title|
  let(:model) { subject.class }
  let(:record) { create(model.name.underscore) }

  it 'has slug' do
    expect { record.slug }.not_to raise_error
  end

  it 'creates slug after record is created' do
    new_record = create(model.name.underscore, sluggable_field => 'Hello world!!')
    expect(new_record.slug).to eq 'hello-world'
  end

  it 'updates slug after record title is updated' do
    record.update(sluggable_field => 'Hello world 2!')
    expect(record.reload.slug).to eq 'hello-world-2'
  end

  it 'does not fail transliterating ukrainian string' do
    record.update(sluggable_field => 'Привіт сьвїт ґҐ')
    expect(record.reload.slug).to eq 'pryvit-svit-gg'
  end
end
