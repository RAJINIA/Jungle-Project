require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Validations" do
    before(:each) do
      @user = User.new(
        first_name: "Shampoo",
        last_name: "Champloo",
        email: "whataboutit@what.com",
        password: "Lindburgh",
        password_confirmation: "Lindburgh"
      )
      @user.save
    end

    context "Basic fields" do
      it "should pass when the user is created with proper values" do
        expect(@user).to be_valid
      end

      it "requires a password" do
        @user.password = nil
        expect(@user).to be_invalid
        expect(@user.errors.full_messages.include?("Password can't be blank")).to be_truthy
      end

      it "requires password confirmation" do
        @user.password_confirmation = nil
        expect(@user).to be_invalid
        expect(@user.errors.full_messages.include?("Password confirmation can't be blank")).to be_truthy
      end

      it "requires a first name" do
        @user.first_name = nil
        expect(@user).to be_invalid
        expect(@user.errors.full_messages.include?("First name can't be blank")).to be_truthy
      end

      it "requires a last name" do
        @user.last_name = nil
        expect(@user).to be_invalid
        expect(@user.errors.full_messages.include?("Last name can't be blank")).to be_truthy
      end

      it "requires an email" do
        @user.email = nil
        expect(@user).to be_invalid
        expect(@user.errors.full_messages.include?("Email can't be blank")).to be_truthy
      end
    end

    it "should fail when password and password confirmation are not the same" do
      @user.password_confirmation = 'Hamlord'
      expect(@user).to be_invalid
      expect(@user.errors.full_messages.include?("Password confirmation doesn't match Password")).to be_truthy
    end

    context "Email testing" do
      it "should fail when emails are the same" do
        @user2 = User.create(
          first_name: "Shampoo",
          last_name: "Champloo",
          email: "whataboutit@what.com",
          password: "Lindburgh",
          password_confirmation: "Lindburgh"
        )
        @user2.save
        expect(@user2.errors.full_messages.include?("Email has already been taken")).to be_truthy
      end

      it "should be case-insensitive" do
        @user2 = User.create(
          first_name: "Shampoo",
          last_name: "Champloo",
          email: "WHATABOUTIT@what.com",
          password: "Lindburgh",
          password_confirmation: "Lindburgh"
        )
        @user2.save
        expect(@user2.errors.full_messages.include?("Email has already been taken")).to be_truthy
      end
    end
  end

  describe ".authenticate_with_credentials" do
    before(:each) do
      @user = User.create(
        first_name: "Billiam",
        last_name: "Sharkspear",
        email: "BILLY@POEMS.COM",
        password: "test",
        password_confirmation: "test",
      )
    end

    it "should return user with correct login credentials" do
      user = User.authenticate_with_credentials("BILLY@POEMS.COM", "test")
      expect(user).to be_kind_of User
    end

    it "should return nil for invalid email" do
      user = User.authenticate_with_credentials("williamth@SHMOE.COM", "test")
      expect(user).to be_nil
    end

    it "should return nil for invalid password" do
      user = User.authenticate_with_credentials("BILLY@POEMS.COM", "lolbutts")
      expect(user).to be_nil
    end

    it "should return a user despite whitespace" do
      user = User.authenticate_with_credentials(" BILLY@POEMS.COM ", "test")
      expect(user).to be_kind_of User
    end

    it "should be case insensitive" do
      user = User.authenticate_with_credentials("BiLlY@pOeMs.CoM", "test")
      expect(user).to be_kind_of User
    end
  end

end