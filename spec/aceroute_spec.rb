require 'spec_helper'

describe Aceroute do


  describe 'basics' do
    it 'has a version number' do
      expect(Aceroute::VERSION).not_to be nil
    end

    it 'does something useful' do
      expect(true).to eq(true)
    end
  end

  xdescribe 'Aceroute.list_customers returns list of Customer objects' do
    before do
      @customers = Aceroute.list_customers
    end
    it "returns list of Customers" do
      expect(@customers.class).to eq Array
    end

    it "list contains Customer objects" do
      expect(@customers.first.class).to eq Aceroute::Customer
    end

  end

end
