require 'rails_helper'

RSpec.describe User, type: :model do
  

  #モデルの属性をちゃんとcreateできるか
  it "is valid with a name, email" do
    user = User.new(name: "ryoro", email: "ryoro@example.com", password: "hogehoge", password_confirmation: "hogehoge")
    expect(user).to be_valid
  end

  it "is invalid without name" do
    user = User.new(name: nil)
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
  end

  it "is invalid without email" do
    user = User.new(email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it "is invalid with too long name" do
    user = User.new(name: "s"*51)
    user.valid?
    expect(user.errors[:name]).to include("is too long (maximum is 50 characters)")
  end

  it "is invalid with too long email" do
    user = User.new(email: "s"*256)
    user.valid?
    expect(user.errors[:email]).to include("is too long (maximum is 255 characters)")
  end

  it "accepts valid format email" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |address|
      user = User.new(email: address)
      expect(user.errors[:email]).to_not include("format error")
    end
  end

  it "don't accepts invalid format email" do
    valid_addresses =  %w[user@example,com user_at_foo.org user.name@example.foo@bar_baz.com foo@bar+baz.com]
    valid_addresses.each do |address|
      user = User.new(name:"ryoro", email: address)
      expect(user).to_not be_valid
    end
  end

  it "should be unique email" do
    User.create(name: "ryoro", email: "hogehoge@email.com", password: "hogehoge", password_confirmation: "hogehoge")

    user = User.new(email: "Hogehoge@email.com")
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end

  it "downcase email sentense" do
    user = User.create(name: "ryoro", email: "HOGEHOGE@email.com", password: "hogehoge", password_confirmation: "hogehoge")
    expect(user.email).to eq "hogehoge@email.com"

  end

  it "is invalid with too minimum password" do
    user = User.new(password: "aa", password_confirmation: "aa")
    user.valid?
    expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
  end


end