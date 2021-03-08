require 'rails_helper'

RSpec.describe User, type: :model do
#  pending "add some examples to (or delete) #{__FILE__}"

  subject {
    described_class.new(name: "Anyone", created_at: Time.now, updated_at: Time.now)
  }

	it "Verifica consegue criar um registro novo" do
	    expect(subject).to be_valid
	end

	it "Não aceita nome vazio" do
	  subject.name = nil
	  expect(subject).to_not be_valid
	end
end
