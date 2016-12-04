require 'spec_helper'

describe Aceroute::Location do

  describe "create a new Location" do
  before :all do
    @address1 = "123 fake st"
    @address2 = "Apt B"
    @description = "Home addr"
    @name = "Home"
    @phone = "5551212"
    @cid = '330001'

    @location = Aceroute::Location.new(@address1, @address2,
    @description, @name, @phone, @cid)
    end


    it "creates a new Location object" do
      expect(@location.class).to eq Aceroute::Location
    end

    it "saves Location to Aceroute" do
      expect(@location.id).to be nil
      @location.create!
      expect(@location.id).to_not be nil
      #expect(Aceroute).to have_received(:call_api).with("location.create")
    end

    it "deletes Location from Aceroute" do
      result = @location.destroy!
      expect(result).to eq true
    end


  end




end
