class DashboardsController < ApplicationController
  def index
    @next_entry = Report.next_entry(current_user)
  end
end
