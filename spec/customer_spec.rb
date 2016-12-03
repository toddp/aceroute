require 'spec_helper'

describe Aceroute::Customer do

describe "create a new Customer" do
  before :all do
    @name =  "Foo"
    @email = "foo@bar.com",
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
    $customer_updated = @customer.create!
    expect($customer_updated.instance_of?(Aceroute::Customer)).to be true
    #expect(Aceroute).to have_received(:call_api).with("customer.create")
  end


  it "deletes customer from Aceroute" do
    result = $customer_updated.destroy!
    expect(result).to eq true
  end

end
end
