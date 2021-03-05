require 'rails_helper'

RSpec.describe Holiday do
  before :each do
    @created = Holiday.new({name: "New years", date: "12/31"})
  end
  it 'can be created' do
    expect(@created.class).to eq(Holiday)
  end

  it 'can possess a name and a date' do
    expect(@created.name).to eq("New years")
    expect(@created.date).to eq("12/31")
  end
end