class DashboardsController < ApplicationController
  def index
    @next_entry = Report.next_entry
  end
end
