require 'spec_helper'
require 'date'
describe Aceroute::Order do

  describe "create a new Order" do
    before :all do
      @location = Aceroute::Location.new(
      "555 Sesame St", "#123", "Big Bird's House", "home",
      "5551234", "330001")

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
      #id will be set by data returned from aceroute
      expect(@order.id).to be nil
      @order.create!
      expect(@order.id).to_not be nil
    end

    it "deletes order from Aceroute" do
      result = @order.destroy!
      expect(result).to eq true
    end

  end
end
