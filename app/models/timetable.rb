class Timetable < ActiveRecord::Base
  belongs_to :user

  validates :closing_day, presence: true
  validates :closing_day, uniqueness: { scope: :user_id }

  default_scope { order('closing_day DESC') }

  def balance
    start_day = last_timetable ? last_timetable.closing_day : user.reports.last_day
    user.balance_in_range(start_day, closing_day)
  end

  private

  def last_timetable
    @last ||= user.timetables.where('closing_day < ?', closing_day).select(:closing_day).first
  end
end
