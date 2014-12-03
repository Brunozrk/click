class ReportsController < ApplicationController
  before_action :authenticate_user!

  before_action :initialize_report, only: [:new, :create]
  before_action :load_report, only: [:edit, :update, :destroy]
  before_action :require_permission, only: [:edit, :update, :destroy]

  PDF_OPTIONS = {
    :page_size   => "A5",
    :page_layout => :landscape,
    #:background  => "public/images/cert_bg.png",
    :margin      => [40, 75]
  }

  def export
    @from = from
    @to = to
    reports = current_user.reports.find_by_date_range(@from, @to)

    Prawn::Document.new(PDF_OPTIONS) do |pdf|

      #pdf.image "/images/stef.jpg", :position => position



      pdf.fill_color "40464e"
      pdf.text "Ruby Metaprogramming", :size => 18, :style => :bold, :align => :center

      table_data = [["<b>1. Row example text</b>\n\nExample Text Not Bolded", "<b>433<b>"], 
                    ["<b>2. Row example text</b>", "<b>2343</b>"], 
                    ["<i>3. Row example text</i>", "<i>342</i>"],
                    ["<b>4. Row example text</b>", "<sub>36</sub>"]]

      pdf.table(table_data, :width => 500, :cell_style => { :inline_format => true })

      reports.each do |report|
        pdf.table(
          [
            [
              report.day.strftime('%d/%m/%Y'),
              report.first_entry.to_s,
              report.first_exit.to_s,
              report.second_entry.to_s,
              report.second_exit.to_s,
              report.remote.to_s,
              report.worked_hour_minute.to_s,
              report.balance[:time].to_s
            ]
          ]
        )
      end


      pdf.move_down 30
      pdf.text "Certificado", :size => 24, :align => :center, :style => :bold

      pdf.move_down 30
      pdf.text "Certificamos que <b>Nando Vieira</b> participou...", :inline_format => true

      pdf.move_down 15
      pdf.text "SÃ£o Paulo, "

      pdf.move_down 30
      #pdf.font Rails.root.join("fonts/custom.ttf")
      pdf.text "howto", :size => 24

      pdf.move_up 5
      pdf.font "Helvetica"
      pdf.text "http://howtocode.com.br", :size => 10

      send_data pdf.render, filename: 'summary_report.pdf', type: 'application/pdf', disposition: 'inline'
    end

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
