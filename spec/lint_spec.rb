require 'rails_helper'

describe "FactoryGirl Lint" do
  before do
    allow_any_instance_of(PaymentMethod).to receive(:valid_card_information)
  end

  it "passes validation" do
    FactoryGirl.lint
  end
end
