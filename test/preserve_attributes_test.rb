require 'test_helper'

class User < ActiveRecord::Base
  preserve_attributes_if_nil :password
end

class PreserveAttributesTest < ActiveSupport::TestCase
  test "value is not cleared if passed as nil" do
    User.delete_all

    User.create_or_update(:id => 1, :login => "user1", :password => "p4ssword")
    assert_equal User.count, 1
    u = User.first
    assert_equal u.password, "p4ssword"

    u.update_attributes({:login => "user2", :password => nil})

    u = User.first
    assert_equal u.password, "p4ssword"
    assert_equal u.login, "user2"
  end
end
