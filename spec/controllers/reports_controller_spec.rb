require 'rails_helper'

describe ReportsController do
  login_user

  describe 'GET #export' do
    before do
      get :export
    end

    it "must be a PDF" do
      expect(Report.export(assigns(:reports)).render[1,3]).to eq('PDF')
    end
  end

  describe 'GET #index' do
    let(:page) { '3' }

    context 'when filter reports by date range' do
      let(:from) { '03/02/2014' }
      let(:to) { '04/02/2014' }

      before do
        get :index, from: from, to: to
      end

      it 'the maximum day date should be greater than #{from}' do
        expect(assigns(:reports).max_by(&:day).day).to be > Date.parse(from)
      end

      it 'the minimum day date should be less than #{to}' do
        expect(assigns(:reports).min_by(&:day).day).to be < Date.parse(to)
      end
    end

    context 'when date range invalid' do
      let(:invalid_from) { '66/48/2014' }
      let(:invalid_to) { 'invalid' }

      before do
        get :index, from: invalid_from, to: invalid_to
      end

      it 'should assign 30 days ago to #from' do
        expect(assigns(:from).to_date).to eq 30.days.ago.to_date
      end

      it 'should assign currente date to #to' do
        expect(assigns(:to).to_date).to eq Date.today.to_date
      end
    end

    it 'should load the reports of requested page' do
      expect(Report).to receive(:page).with(page)
      get :index, page: page
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'assigns a new Report to @report' do
      expect(assigns(:report)).to be_a_new(Report)
    end

    it 'assigns \'Today\' as default to \'day\' field' do
      expect(assigns(:report).day).to eq Date.today
    end
  end

  describe 'POST #create' do
    let(:report_params) do
      {
        report: {
          first_entry: '08:00',
          first_exit: '12:00',
          second_entry: '14:00',
          second_exit: '18:00',
          remote: '03:00',
          day: Date.today
        }
      }
    end

    context 'with valid params' do
      it 'save a report' do
        expect do
          post :create, report_params
        end.to change { Report.count }.by(1)
      end

      it 'redirect to report listing' do
        post :create, report_params
        expect(response).to redirect_to(reports_path)
      end
    end

    context 'with invalid params' do
      it 'render new template' do
        report_params[:report].merge!(day: '')
        post :create, report_params
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    let(:edit_report) { reports(:report_user_logged_in_1) }
    let(:unallowed_report) { reports(:unallowed_report) }

    context 'when the current_user is the report owner' do
      it 'assigns edit_report to @report' do
        get :edit, id: edit_report.id
        expect(assigns(:report)).to eq(edit_report)
      end
    end

    context 'when the current_user is NOT the report owner' do
      it 'redirect to report listing' do
        get :edit, id: unallowed_report.id
        expect(response).to redirect_to(reports_path)
      end
    end
  end

  describe '#PUT update' do
    let(:edit_report) { reports(:report_user_logged_in_1) }
    let(:report_params) do
      {
        first_entry: edit_report.first_entry,
        first_exit: edit_report.first_exit,
        second_entry: edit_report.second_entry,
        second_exit: edit_report.second_exit,
        remote: '03:30',
        day: edit_report.day
      }
    end

    let(:params) do
      {
        id: edit_report.id,
        report: report_params
      }
    end

    before do
      allow(Report).to receive(:find).and_return(edit_report)
    end

    context 'with valid params' do
      it 'update the remote field' do
        expect do
          put :update, params
        end.to change(edit_report, :remote)
      end

      it 'redirect to report listing' do
        put :update, params
        expect(response).to redirect_to(reports_path)
      end
    end

    context 'with invalid params' do
      it 'render edit template' do
        params[:report].merge!(day: '')
        put :update, params
        expect(response).to render_template(:edit)
      end
    end
  end

  describe '#DELETE destroy' do
    let(:deleted_report) { reports(:report_user_logged_in_1) }
    let(:unallowed_report) { reports(:unallowed_report) }

    context 'when the current_user is the report owner' do
      it 'remove the report' do
        delete :destroy, id: deleted_report.id
        expect(Report.where(id: deleted_report.id)).to be_empty
      end

      it 'redirect to report listing' do
        delete :destroy, id: deleted_report.id
        expect(response).to redirect_to(reports_path)
      end
    end

    context 'when the current_user is NOT the report owner' do
      it 'not remove the report' do
        delete :destroy, id: unallowed_report.id
        expect(Report.where(id: unallowed_report.id)).to_not be_empty
      end
    end
  end
end
