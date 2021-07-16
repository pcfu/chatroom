require 'rails_helper'

RSpec.describe Community, type: :model do
  subject(:comm)      { build_stubbed :community }
  subject(:ctrl_comm) { create :control_community }

  it { is_expected.to be_valid }

  describe "#name" do
    it "is required" do
      generate_blanks.each do |name|
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

    it "is unique" do
      comm.name = ctrl_comm.name
      comm.valid?
      expect(comm.errors[:name]).to include("has already been taken")
    end
  end

  describe "#description" do
    it "is required" do
      generate_blanks.each do |desc|
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

  describe "#access" do
    it "is required" do
      generate_blanks.each do |access|
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
  end

  it "downcases name on validate" do
    comm.name = attributes_for(:community, :name_uppercase)[:name]
    comm.valid?
    expect(comm.name).to eq(comm.name.downcase)
  end
end
