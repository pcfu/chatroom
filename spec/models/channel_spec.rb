require 'rails_helper'

RSpec.describe Channel, type: :model do
  let(:user)    { build_stubbed :user }
  let(:comm)    { create :community }
  let(:ctrl_ch) { create(:control_channel, :community_id => comm.id) }
  subject(:ch)  { build_stubbed(:channel, :community_id => comm.id) }

  it { is_expected.to be_valid }

  describe "#name" do
    it "is required" do
      blank_strings.each do |name|
        ch.name = name
        ch.valid?
        expect(ch.errors[:name]).to include("can't be blank")
      end
    end

    it "has at least #{Channel::MIN_NAME_LEN} chars" do
      ch.name = attributes_for(:channel, :name_too_short)[:name]
      ch.valid?
      expect(ch.errors[:name]).to include(/is too short/)
    end

    it "has at most #{Channel::MAX_NAME_LEN} chars" do
      ch.name = attributes_for(:channel, :name_too_long)[:name]
      ch.valid?
      expect(ch.errors[:name]).to include(/is too long/)
    end

    it "has no spaces" do
      ch.name = attributes_for(:channel, :name_with_spaces)[:name]
      ch.valid?
      expect(ch.errors[:name]).to include("is invalid")
    end

    it "has no special characters besides dash" do
      name = attributes_for(:channel, :name_with_dashes)[:name]
      ch.name = name
      expect(ch).to be_valid

      special_chars.gsub('-', '').split('').each do |char|
        ch.name = "special#{char}chars"
        ch.valid?
        expect(ch.errors[:name]).to include("is invalid")
      end
    end

    it "does not start or end with a dash" do
      %i(name_dash_start name_dash_end).each do |trait|
        ch.name = attributes_for(:channel, trait)[:name]
        ch.valid?
        expect(ch.errors[:name]).to include("is invalid")
      end
    end

    it "does not have consecutive dashes" do
      ch.name = attributes_for(:channel, :name_consecutive_dashes)[:name]
      ch.valid?
      expect(ch.errors[:name]).to include("is invalid")
    end

    it "is unique per channel" do
      ch.name = ctrl_ch.name
      ch.valid?
      expect(ch.errors[:name]).to include("has already been taken")

      ch.community = create(:control_community)
      expect(ch).to be_valid
    end

    it "is downcased on validate" do
      ch.name = attributes_for(:channel, :name_uppercase)[:name]
      ch.valid?
      expect(ch.name).to eq(ch.name.downcase)
    end
  end

  describe "#description" do
    it "has at most #{Channel::MAX_DESC_LEN} chars" do
      ch.description = attributes_for(:channel, :desc_too_long)[:description]
      ch.valid?
      expect(ch.errors[:description]).to include(/is too long/)
    end
  end

  describe "#associations" do
    it "is destroyed when associated community is destroyed" do
      ch =  create(:channel, :community_id => comm.id)
      Community.find_by(:handle => 'TEST').destroy
      expect(Channel.where(:name => ch.name)).to_not exist
    end
  end

  describe "#methods" do
    describe "user_has_access?" do
      it "returns true if user is a member of community" do
        user.memberships.create(community: comm)
        expect(ch.user_has_access? user).to be true
      end

      it "returns false if user is not a member of community" do
        expect(ch.user_has_access? user).to be false
      end
    end
  end
end
