require 'rails_helper'

describe Report do
  context 'relations' do
    it { expect(subject).to belong_to(:user) }
  end

  context 'validations' do
    context 'presence of' do
      it { expect(subject).to validate_presence_of(:day) }
      it { expect(subject).to validate_presence_of(:remote) }
    end

    context 'uniqueness of' do
      it { expect(subject).to validate_uniqueness_of(:day).scoped_to(:user_id) }
    end

    context 'validate_entry_exit_order' do
      let(:report) { build(:report, first_entry: '12:00', second_entry: '11:00') }
      let(:report_case_2) { build(:report, second_entry: '11:00') }

      it { expect(report).to_not be_valid }
      it { expect(report_case_2).to_not be_valid }

      it 'contains base error' do
        report.valid?
        expect(report.errors[:base].size).to eq(1)
      end
    end
  end

  context 'with new instance' do
    let(:report) { build(:report) }
    it 'should be valid' do
      expect(report).to be_valid
    end
  end

  describe '#worked' do
    let(:report) { build(:report) }
    it { expect(report.worked).to eq 8.hour }
  end

  describe '#balance' do
    let(:report_positive) { build(:report, second_exit: '19:00') }
    let(:report_negative) { build(:report, second_exit: '17:00') }
    let(:report_away) { build(:report, away: true) }
    let(:report_nonworking_day) { build(:report, working_day: false) }

    context 'when positive balance' do
      it { expect(report_positive.balance).to eq(time: 3600.0, sign: true) }
    end

    context 'when negative balance' do
      it { expect(report_negative.balance).to eq(time: 3600.0, sign: false) }
    end

    context 'when away' do
      it { expect(report_away.balance).to eq(time: 28_800.0, sign: false) }
    end

    context 'when nonworking day' do
      it { expect(report_nonworking_day.balance).to eq(time: 28_800.0, sign: true) }
    end
  end

  describe '.find_by_date_range' do
    let(:date) { Date.new(2014, 02, 03)  }
    it 'find reports by date range' do
      expect(described_class.find_by_date_range(date, date).count).to eq 3
    end
  end

  describe '.next_entry' do
    let!(:report) do
      create(:report, day: date, first_exit: first_exit, second_entry: second_entry, second_exit: second_exit)
    end
    subject { described_class.next_entry }
    let(:first_exit) { '12:00' }
    let(:second_entry) { '13:00' }
    let(:second_exit) { '17:00' }

    context 'when the last report is on friday' do
      let(:date) { Date.new(2015, 03, 27) }

      it { should be nil }
    end

    context 'when the last report is on a work day and have both exists' do
      let(:date) { Date.new(2015, 04, 1) }
      let(:expected_date) { DateTime.new(2015, 04, 02, 04, 00) }

      it { should eq expected_date }
    end

    context 'when the last report is on a work day and have only the first exist' do
      let(:date) { Date.new(2015, 04, 1) }
      let(:second_exit) { nil }
      let(:expected_date) { DateTime.new(2015, 04, 01, 23, 00) }

      it { should eq expected_date }
    end

    context 'when are missing both exits' do
      let(:date) { Date.new(2015, 04, 1) }
      let(:first_exit) { nil }
      let(:second_entry) { nil }
      let(:second_exit) { nil }

      it { should be nil }
    end
  end
end
