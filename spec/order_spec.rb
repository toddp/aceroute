require 'spec_helper'
require 'date'
describe Aceroute::Order do

  describe "create a new Order" do
    before :all do
      @location = Aceroute::Location.new(
      "555 Sesame St", "#123", "Big Bird's House", "home",
      "5551234", "330001")
      @location.create!

      @customer = Aceroute::Customer.new(
      "Big Bird", "big@bird.com")
      @customer.locations << @location
      @customer.create!

      @start_time = DateTime.now.to_time.to_i * 1000
      @description = "This is a test order"
      @duration = 10 #minutes
      @scheduled = true
      @worker = '1001'  #hard-code worker id for now
      @summary = "This is a test order. Please delete."
      @purchase_order = "For 1000 blue widgets"
      @order = Aceroute::Order.new(@customer, @location,
      @start_time, @description, @duration, @scheduled, @worker, @summary,
      @purchase_order)
    end

    after :all do
      @location.destroy!
      @customer.destroy!
    end

    it "creates a new Order object" do
      expect(@order.class).to eq Aceroute::Order
    end

    it "saves order to Aceroute" do
      $order_updated = @order.create!
      expect($order_updated.instance_of?(Aceroute::Order)).to be true
      #expect(Aceroute).to have_received(:call_api).with("customer.create")
    end


    it "deletes order from Aceroute" do
      result = $order_updated.destroy!
      expect(result).to eq true
    end




  end
end