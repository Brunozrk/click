class Report < ActiveRecord::Base
  
  belongs_to :user

  validates :day, :remote, presence: true

  validates :day, uniqueness: { scope: :user_id }

  validate :validate_entry_exit_order

  default_scope { order('day DESC') }

  PDF_OPTIONS = { :page_size   => "A4", :page_layout => :landscape, :margin => [40, 75] }

  def self.export(reports)
    pdf_file = Prawn::Document.new(PDF_OPTIONS) do |pdf|
      pdf.fill_color "40464e"
      pdf.text "<b><i>Click</i></b>", :size => 30, :align => :left, :inline_format => true
      pdf.text "Relatório de Horas", :size => 18, :style => :bold, :align => :center

      table_header = [
        ["<b>Dia</b>", "<b>Primeira Entrada</b>", "<b>Primeira Saída</b>", "<b>Segunda Entrada</b>",
          "<b>Segunda Saída</b>", "<b>Remoto</b>", "<b>Total</b>", "<b>Saldo</b>"], 
      ]

      pdf.fill_color "00000"

      pdf.table(
        table_header,
        :column_widths => [165, 75, 75, 75, 75, 75, 75, 75],
        :row_colors => ["EEEEEE"],
        :cell_style => { :inline_format => true }
      )

      table_data, row_colors = [], []
      reports.each_with_index do |report, index|
        table_data <<
        [
          report.day.strftime('%d/%m/%Y'),
          report.first_entry.to_s,
          report.first_exit.to_s,
          report.second_entry.to_s,
          report.second_exit.to_s,
          report.remote.to_s,
          "<b>#{ApplicationController.helpers.hour_minute(report.worked)}</b>",
          "<b>#{ApplicationController.helpers.hour_minute(report.balance[:time])}</b>"
        ]
        row_colors << (index.even? ? "FFFFFF" : "F5F5F5")
      end

      pdf.table(
        table_data,
        :column_widths => [165, 75, 75, 75, 75, 75, 75, 75],
        :row_colors => row_colors,
        :cell_style => { :inline_format => true }
      ) unless table_data.empty?

      pdf.number_pages "page <page> of <total>", {
        :at => [pdf.bounds.right - 150, 0],
        :width => 150,
        :align => :right,
        :color => "A0A0A0"
      }
    end
    
    return pdf_file

  end

  def worked
    first_total = time_diff(first_entry, first_exit)
    second_total = time_diff(second_entry, second_exit)
    first_total + second_total + timeit(remote).seconds_since_midnight
  end

  def balance
    hours_per_day = user.hours_per_day
    if away
      { time: hours_per_day.hour, sign: false }
    elsif hours_per_day.hour > worked
      { time: hours_per_day.hour - worked, sign: false }
    else
      { time: worked - hours_per_day.hour, sign: true }
    end
  end

  def estimated_exit
    return unless can_estimate?
    Time.parse(second_entry) + balance.fetch(:time)
  end

  def self.find_by_date_range(from, to)
    where('day >= ? AND day <= ?', from, to)
  end

  def self.last_day
    last ? last.day : Date.today
  end

  private

  def can_estimate?
    return false unless second_exit.blank?
    [first_entry, first_exit, second_entry].each do |f|
      return false if f.blank?
    end
    true
  end

  def validate_entry_exit_order
    return unless any_higher?(first_entry, 3) ||
                  any_higher?(first_exit, 2) ||
                  any_higher?(second_entry, 1)
    errors.add(:base, 'Sequência de entrada/saída inválida')
  end

  def any_higher?(value, lasts)
    (times.last(lasts).compact).any? { |x| x < timeit(value) }
  end

  def times
    [
      timeit(first_entry),
      timeit(first_exit),
      timeit(second_entry),
      timeit(second_exit)
    ]
  end

  def time_diff(entry, exit)
    entry = timeit(entry)
    exit = timeit(exit)
    if exit && entry
      exit - entry
    else
      0
    end
  end

  def timeit(value)
    return if value.nil?
    Time.parse(value) unless value.empty?
  end
end
