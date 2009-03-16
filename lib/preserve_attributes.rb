class << ActiveRecord::Base
  attr_reader :preserved_nil_attributes

  def preserve_attribute_if_nil(attr)
    @preserved_nil_attributes ||= []
    @preserved_nil_attributes << attr
  end

  def preserve_attributes_if_nil(*args)
    @preserved_nil_attributes ||= []
    @preserved_nil_attributes << [args]
    @preserved_nil_attributes.flatten!
  end
end

class ActiveRecord::Base
  alias_method :orig_update_attributes, :update_attributes
  def update_attributes(attributes)
    self.class.preserved_nil_attributes.each do |attr|
      attributes.delete(attr.to_s) if attributes[attr.to_s].nil? || attributes[attr.to_s] == ''
    end unless self.class.preserved_nil_attributes.nil?

    orig_update_attributes(attributes)
  end
end
