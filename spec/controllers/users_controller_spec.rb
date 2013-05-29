require 'spec_helper'
describe UsersController do
  let(:user){FactoryGirl.create(:user)}

  before{sign_in user}

  describe "POST sort" do
    before :each do
      @users = {}
      5.times do |i|
        @users[i] = FactoryGirl.create(:user)
      end
    end

    it "should put the user just after his successor with Ajax" do
      xhr :post, :sort, {id: @users[0].id, next: @users[3].id }
      @users[0].reload.row_order.should be > @users[2].reload.row_order
      @users[0].reload.row_order.should be < @users[3].reload.row_order
    end

    it "should put the user at the end with Ajax" do
      xhr :post, :sort, {id: @users[0].id, last: @users[4].id }
      @users[0].reload.row_order.should be > @users[4].reload.row_order
    end
  end
end
