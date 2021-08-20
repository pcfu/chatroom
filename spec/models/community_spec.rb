require 'rails_helper'

RSpec.describe Community, type: :model do
  subject(:comm)  { build_stubbed :community }
  let(:ctrl_comm) { create :control_community }

  it { is_expected.to be_valid }

  describe "#name" do
    it "is required" do
      blank_strings.each do |name|
        comm.name = name
        comm.valid?
        expect(comm.errors[:name]).to include("can't be blank")
      end
    end

    it "has at least #{Community::MIN_CNAME_LEN} chars" do
      comm.name = attributes_for(:community, :name_too_short)[:name]
      comm.valid?
      expect(comm.errors[:name]).to include(/is too short/)
    end

    it "has at most #{Community::MAX_CNAME_LEN} chars" do
      comm.name = attributes_for(:community, :name_too_long)[:name]
      comm.valid?
      expect(comm.errors[:name]).to include(/is too long/)
    end

    it "is case-insensitive unique" do
      comm.name = ctrl_comm.name.upcase
      comm.valid?
      expect(comm.errors[:name]).to include("has already been taken")
    end
  end

  describe "#description" do
    it "is required" do
      blank_strings.each do |desc|
        comm.description = desc
        comm.valid?
        expect(comm.errors[:description]).to include("can't be blank")
      end
    end

    it "has at most #{Community::MAX_DESC_LEN} chars" do
      comm.description = attributes_for(:community, :desc_too_long)[:description]
      comm.valid?
      expect(comm.errors[:description]).to include(/is too long/)
    end
  end

  describe "#handle" do
    it "is required" do
      blank_strings.each do |handle|
        comm.handle = handle
        comm.valid?
        expect(comm.errors[:handle]).to include("can't be blank")
      end
    end

    it "has at least #{Community::MIN_HANDLE_LEN} chars" do
      comm.handle = attributes_for(:community, :handle_too_short)[:handle]
      comm.valid?
      expect(comm.errors[:handle]).to include(/is too short/)
    end

    it "has at most #{Community::MAX_HANDLE_LEN} chars" do
      comm.handle = attributes_for(:community, :handle_too_long)[:handle]
      comm.valid?
      expect(comm.errors[:handle]).to include(/is too long/)
    end

    it "has no numbers" do
      comm.handle = attributes_for(:community, :handle_with_numbers)[:handle]
      comm.valid?
      expect(comm.errors[:handle]).to include("is invalid")
    end

    it "has no special characters" do
      special_chars.split('').each do |char|
        comm.handle = "T#{char}"
        comm.valid?
        expect(comm.errors[:handle]).to include("is invalid")
      end
    end

    it "is unique" do
      comm.handle = ctrl_comm.handle
      comm.valid?
      expect(comm.errors[:handle]).to include("has already been taken")
    end

    it "it upcased on validate" do
      comm.handle = attributes_for(:community, :handle_lowercase)[:handle]
      comm.valid?
      expect(comm.handle).to eq(comm.handle.upcase)
    end
  end

  describe "#access" do
    it "is required" do
      blank_strings.each do |access|
        comm.access = access
        comm.valid?
        expect(comm.errors[:access]).to include("can't be blank")
      end
    end

    it "accepts only enum values" do
      %w[public private].each do |enum_val|
        comm.access = enum_val
        comm.valid?
        expect(comm).to be_valid
      end

      expect {
        comm.access = 'unknown'
      }.to raise_error(ArgumentError).with_message(/is not a valid access/)
    end

    it "defaults to public on initialize" do
      comm = Community.new
      expect(comm.public_access?).to be true
    end
  end

  describe "#associations" do
    it "adds general channel on create" do
      expect(Channel.where(community_id: ctrl_comm.id, name: 'general')).to exist
    end

    it "adds announcements channel on create" do
      expect(Channel.where(community_id: ctrl_comm.id, name: 'announcements')).to exist
    end
  end
end
