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
      let(:report) { FactoryGirl.build(:report, first_entry: '12:00', second_entry: '11:00') }

      it { expect(report).to_not be_valid }

      it 'contains base error' do
        report.valid?
        expect(report.errors[:base].size).to eq(1)
      end
    end
  end

  context 'with new instance' do
    let(:report) { FactoryGirl.build(:report) }
    it 'should be valid' do
      expect(report).to be_valid
    end
  end

  describe '#worked' do
    let(:report) { FactoryGirl.build(:report) }
    it { expect(report.worked).to eq 8.hour }
  end

  describe '#balance' do
    let(:report_positive) { FactoryGirl.build(:report, second_exit: '19:00') }
    let(:report_negative) { FactoryGirl.build(:report, second_exit: '17:00') }
    let(:report_nonworking_day) { FactoryGirl.build(:report, working_day: false) }

    context 'when positive balance' do
      it { expect(report_positive.balance).to eq(time: 3600.0, sign: true) }
    end

    context 'when negative balance' do
      it { expect(report_negative.balance).to eq(time: 3600.0, sign: false) }
    end

    context 'when nonworking day' do
      it { expect(report_nonworking_day.balance).to eq(time: 28_800.0, sign: true) }
    end
  end

  describe 'estimated_exit' do
    let(:report_without_second_exit) { FactoryGirl.build(:report_without_second_exit) }
    let(:report) { FactoryGirl.build(:report) }

    context 'when first_entry, first_exit and second_entry are filled && second_exit is NOT filled)' do
      it { expect(report_without_second_exit.estimated_exit.hour).to eq 18 }
      it { expect(report_without_second_exit.estimated_exit.min).to eq 30 }
    end

    context 'when first_entry or first_exit or second_entry are NOT filled || second_exit is filled)' do
      it { expect(report.estimated_exit).to eq nil }
    end
  end

  describe '#self.find_by_date_range' do
    let(:date) { Date.new(2014, 02, 03)  }
    it 'find reports by date range' do
      expect(described_class.find_by_date_range(date, date).count).to eq 3
    end
  end

  describe '.export' do
    let(:reports) { FactoryGirl.build_list(:repor_with_random_date, 85) }
    let(:pdf_file) { Report.export(reports) }
    let(:pdf_text) { PDF::Inspector::Text.analyze(pdf_file.render).strings.join(" ").squish }

    it "must be a PDF" do
      expect(pdf_file.render[1,3]).to eq('PDF')
    end

    it 'includes report title' do
      expect(pdf_text).to include("Relatório de Horas")
    end

    it 'check number of page' do
      page_analysis = PDF::Inspector::Page.analyze(pdf_file.render)
      expect(page_analysis.pages.size).to eq 5
    end
  end

end
