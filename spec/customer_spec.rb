require 'spec_helper'

describe Aceroute::Customer do

describe "create a new Customer" do
  before :all do
    @name =  "Bob Smith"
    @email = "bob@example.com",
    @location =
             {address1: "123 fake st",
              address2: "Apt B",
              description: "Home addr",
              name: "Home",
              phone: "5551212"
            }

    @customer = Aceroute::Customer.new(@name, @email, @location)
  end
  it "creates a new customer object" do
    expect(@customer.class).to eq Aceroute::Customer
  end

  before(:all) do
    #FIXME: build mock response and use here
    #allow(Aceroute).to receive(:call_api).with("customer.create", /.*/).and_return(nil)
  end
  it "saves customer to Aceroute" do
    expect(@customer.id).to be nil
    @customer.create!
    expect(@customer.id).to_not be nil
    #expect(Aceroute).to have_received(:call_api).with("customer.create")
  end

  it "deletes customer from Aceroute" do
    result = @customer.destroy!
    expect(result).to eq true
  end

end
end
