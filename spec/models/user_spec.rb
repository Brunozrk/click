require 'rails_helper'

describe User do
  context 'relations' do
    it { expect(subject).to have_many(:reports) }
    it { expect(subject).to have_many(:timetables) }
  end

  context 'validations' do
    context 'presence of' do
      it { expect(subject).to validate_presence_of(:first_name) }
      it { expect(subject).to validate_presence_of(:last_name) }
      it { expect(subject).to validate_presence_of(:email) }
      it { expect(subject).to validate_presence_of(:password) }
      it { expect(subject).to validate_presence_of(:hours_per_day) }
    end

    context 'uniqueness of' do
      it { expect(subject).to validate_uniqueness_of(:email) }
    end

    context 'inclusion' do
      it { expect(subject).to validate_inclusion_of(:hours_per_day).in_range(1..24) }
    end
  end

  context 'with new instance' do
    let(:user) { FactoryGirl.build(:user) }
    it 'should be valid' do
      expect(user).to be_valid
    end
  end

  describe '#total_balance' do
    let(:user_positive) { users(:user_positive) }
    let(:user_negative) { users(:user_negative) }
    let(:user_logged_in) { users(:user_logged_in) }

    context 'when positive balance' do
      it { expect(user_positive.total_balance).to eq(time: 1800.0, sign: true) }
    end

    context 'when negative balance' do
      it { expect(user_negative.total_balance).to eq(time: 9000.0, sign: false) }
    end

    context 'when user has a timetable closed' do
      it { expect(user_logged_in.total_balance).to eq(time: 16_200.0, sign: false) }
    end
  end

  describe '#balance_in_range' do
    let(:user) { users(:user_logged_in) }
    let(:from) { Date.new(2014, 02, 01) }
    let(:to) { Date.new(2014, 02, 05) }

    it 'returns user balance in specific range' do
      expect(user.balance_in_range(from, to)).to eq(time: 27_000.0, sign: false)
    end
  end
end
