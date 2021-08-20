require 'rails_helper'

RSpec.describe Membership, type: :model do
  subject(:user)        { create :user }
  subject(:comm)        { create :community }

  subject(:membership)  do
    user.memberships.build(community: comm, role: 'regular')
  end

  it { is_expected.to be_valid }

  it "is unique per user" do
    new_comm = create(:control_community)
    user.memberships.create(community: new_comm)
    membership = user.memberships.build(community: new_comm)
    membership.valid?
    expect(membership.errors[:community_id]).to include("has already been taken")
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
      membership = user.memberships.build(community: comm)
      expect(membership.role).to eq('regular')
    end
  end

  describe "#associations" do
    it "is destroyed when associated user is destroyed" do
      membership.save
      user.destroy
      expect(Membership.where(community: comm)).to_not exist
    end

    it "is destroyed when associated community is destroyed" do
      membership.save
      user.destroy
      expect(Membership.where(community: comm)).to_not exist
    end
  end
end
