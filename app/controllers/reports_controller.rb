
class ReportsController < ApplicationController
  before_action :authenticate_user!

  before_action :initialize_report, only: [:new, :create]
  before_action :load_report, only: [:edit, :update, :destroy]
  before_action :require_permission, only: [:edit, :update, :destroy]

  def export
    @from = from
    @to = to
    reports = current_user.reports.find_by_date_range(@from, @to)
    send_data Report.export(reports).render, filename: 'summary_report.pdf', type: 'application/pdf', disposition: 'inline'
  end

  def new
    @report.day = Date.today
  end

  def index
    @from = from
    @to = to
    @reports = current_user.reports.find_by_date_range(@from, @to).page params[:page]
    render layout: 'print' if params[:print].present?
  end

  def create
    @report.user = current_user
    if @report.update_attributes(report_params)
      redirect_to reports_path, flash: { success: 'Relatório criado!' }
    else
      render 'new'
    end
  end

  def update
    if @report.update_attributes(report_params)
      redirect_to reports_path, flash: { success: 'Relatório atualizado!' }
    else
      render 'edit'
    end
  end

  def destroy
    @report.destroy
    redirect_to reports_path, flash: { success: 'Relatório removido!' }
  end

  private

  def from
    param_or_today(:from, 30.days.ago)
  end

  def to
    param_or_today(:to)
  end

  def param_or_today(key, default = Date.today)
    date = params[key]
    date ? Date.parse(date) : default
  rescue ArgumentError
    default
  end

  def require_permission
    return unless current_user != @report.user
    redirect_to reports_path
  end

  def initialize_report
    @report = Report.new
  end

  def load_report
    @report = Report.find(params[:id])
  end

  def report_params
    params[:report][:first_entry] = "00:00" if params[:report][:first_entry].blank?
    params[:report][:first_exit] = "00:00" if params[:report][:first_exit].blank?
    params[:report][:second_entry] = "00:00" if params[:report][:second_entry].blank?
    params[:report][:second_exit] = "00:00" if params[:report][:second_exit].blank?
    params.require(:report).permit(
      :first_entry,
      :first_exit,
      :second_entry,
      :second_exit,
      :remote,
      :notice,
      :day,
      :away
    )
  end
end
