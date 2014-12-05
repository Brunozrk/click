require 'rails_helper'

describe ReportHelper do
  describe '#sign' do
    context 'when sign is true' do
      let(:balance) { { time: 2700, sign: true } }

      it 'returns html with text-green class' do
        expect(helper.sign(balance)).to include 'text-green'
      end

      it 'returns html with fa-plus-circle class' do
        expect(helper.sign(balance)).to include 'fa-plus-circle'
      end

      it 'returns html with text-white class' do
        expect(helper.sign(balance, 'white')).to include 'text-white'
      end
    end

    context 'when sign is false' do
      let(:balance) { { time: 2700, sign: false } }

      it 'returns html with text-red class' do
        expect(helper.sign(balance)).to include 'text-red'
      end

      it 'returns html with fa-plus-circle class' do
        expect(helper.sign(balance)).to include 'fa-minus-circle'
      end
    end
  end

  describe '#hour_minute' do
    it { expect(helper.hour_minute(8.hour)).to eq '08:00' }
    it { expect(helper.hour_minute(30.hour)).to eq '30:00' }
  end

  describe '#second_exit' do
    let(:report) { FactoryGirl.build(:report) }
    let(:report_without_second_exit) { FactoryGirl.build(:report_without_second_exit) }
    let(:report_without_second_reports) { FactoryGirl.build(:report_without_second_exit, second_entry: '') }

    context 'when second_exit is NOT blank' do
      it { expect(helper.second_exit(report)).to eq report.second_exit }
    end

    context 'when second_exit is blank and estimated_exit exists' do
      let(:expected) do
        "<span title='Saída Estimada' class='text-muted'>
          <i class='fa fa-fw fa-sign-out'></i>
          18:30
        </span>".squish
      end
      it { expect(helper.second_exit(report_without_second_exit).squish).to eq expected }
    end

    context 'when second_exit and estimated_exit are blank' do
      it { expect(helper.second_exit(report_without_second_reports)).to eq nil }
    end
  end

  describe '#pop_over_notice' do
    context 'when notice is blank' do
      let(:notice) { '' }
      it { expect(helper.pop_over_notice(notice)).to be_nil }
    end

    context 'when notice is NOT blank' do
      let(:notice) { 'some text' }
      let(:expected) { "data-toggle='popover' data-content='some text' data-placement='top'" }
      it { expect(helper.pop_over_notice(notice)).to eq expected }
    end
  end
end
