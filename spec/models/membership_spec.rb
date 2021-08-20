require 'rails_helper'

RSpec.describe Membership, type: :model do
  let(:user) { create :user }
  let(:comm) { create :community }

  subject(:membership)  do
    user.memberships.build(community: comm)
  end

  it { is_expected.to be_valid }

  it "is unique per user" do
    membership.save
    membership = user.memberships.build(community: comm)
    membership.valid?
    expect(membership.errors[:community_id]).to include("has already been taken")

    membership = user.memberships.create(community: create(:control_community))
    expect(membership).to be_valid
  end

  describe "#role" do
    it "is required" do
      blank_strings.each do |role|
        membership.role = role
        membership.valid?
        expect(membership.errors[:role]).to include("can't be blank")
      end
    end

    it "accepts only enum values" do
      %w[owner administrator regular banned].each do |enum_val|
        membership.role = enum_val
        membership.valid?
        expect(membership).to be_valid
      end

      expect {
        membership.role = 'unknown'
      }.to raise_error(ArgumentError).with_message(/is not a valid role/)
    end

    it "defaults to regular on initialization" do
      expect(membership.regular?).to be true
    end
  end

  describe "#associations" do
    it "is destroyed when associated user is destroyed" do
      membership.save
      user.destroy
      expect(Membership.where(user: user)).to_not exist
    end

    it "is destroyed when associated community is destroyed" do
      membership.save
      comm.destroy
      expect(Membership.where(community: comm)).to_not exist
    end
  end
end
