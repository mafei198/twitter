require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :name => "Example User", 
              :email => "user@example.com",
              :password => "password",
              :password_confirmation => "password"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    non_name_user = User.new(@attr.merge(:name => ""))
    non_name_user.should_not be_valid
  end

  it "should reject the long name users" do
    long_name = "a"*51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should require a email" do
    non_email_user = User.new(@attr.merge(:email => ""))
    non_email_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w|mafei@gmail.com afda@hotmail.com huangyun@163.com|
    addresses.each  do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w|asf sdfa sdf sadfl.com dsfa@.cl.re adsf|
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
    end
  end
  
  
  describe "password validations" do
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "xxxxx")).
        should_not be_valid
    end

    it "should reject short passwords" do
      short = "aa"
      User.new(@attr.merge(:password => short, :password_confirmation => short)).
        should_not be_valid
    end

    it "should reject long passwords" do
      long = "a"*21
      User.new(@attr.merge(:password => long, :password_confirmation => long)).
        should_not be_valid
    end
  end

  describe "password  encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "authenticate method" do
      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end
      it "should return nil for an email address with no user" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end
      it "should return the user on email/password match" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end
    end

  end

  describe "has_password? method" do
    before(:each) do
      @user = User.create!(@attr)
    end

    it "should return true if matches the submitted password" do
      @user.has_password?(@attr[:password]).should be_true
    end

    it "should returen false if the submitted password doesn't match" do
      @user.has_password?("invalid").should be_false
    end
  end
end
