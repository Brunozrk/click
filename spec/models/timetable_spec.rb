require 'rails_helper'

describe Timetable do
  context 'relations' do
    it { expect(subject).to belong_to(:user) }
  end

  context 'validations' do
    context 'presence of' do
      it { expect(subject).to validate_presence_of(:closing_day) }
    end

    context 'uniqueness of' do
      it { expect(subject).to validate_uniqueness_of(:closing_day).scoped_to(:user_id) }
    end
  end

  describe '#balance' do
    let(:timetable) { timetables(:timetable_1) }

    context 'when specific timetable was closed' do
      it 'calculate the balance until closing day' do
        expect(timetable.balance).to eq(time: 18_000.0, sign: false)
      end
    end
  end
end
