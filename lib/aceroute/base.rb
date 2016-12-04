module Aceroute


# Base class for all other Aceroute module classes to extend.
class Base


  protected
  #takes a Hashit class, extracts the instance variables, and sets them on our instance
  # @param hashit [Hashit] Hashit object, typically created from a response from Aceroute API
  def update_attrs(hashit)
    hashit.instance_variables.each do |name|
      singleton_class.class_eval {attr_accessor "#{name[1..-1]}"} #remove leading @ from varname
      send("#{name[1..-1]}=", hashit.instance_variable_get(name))
    end
  end


end
end
