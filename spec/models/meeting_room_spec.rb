require 'rails_helper'

RSpec.describe MeetingRoom, type: :model do

  subject {
    user = User.create!(name: "User 123")
    described_class.new(name: "Anything", user_id: user.id, local: "Anywhere", status: 1, created_at: Time.now, updated_at: Time.now)
  }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a name" do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a user_id" do
    subject.user_id = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a status" do
    subject.status = nil
    expect(subject).to_not be_valid
  end

end
