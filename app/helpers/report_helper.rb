module ReportHelper
  def sign(balance, color = nil)
    if balance[:sign]
      balance_html(balance[:time], color || 'green', 'plus')
    else
      balance_html(balance[:time], color || 'red', 'minus')
    end
  end

  def hour_minute(worked)
    hours = worked / (60 * 60)
    minutes = (worked / 60) % 60
    format('%02d:%02d', hours, minutes)
  end

  def second_exit(report)
    return report.second_exit unless report.second_exit.blank?
    "<span title='Saída Estimada' class='text-muted'>
      <i class='fa fa-fw fa-sign-out'></i>
      #{ report.estimated_exit.strftime('%H:%M') }
    </span>".html_safe if report.estimated_exit
  end

  def pop_over_notice(notice)
    return if notice.blank?
    "data-toggle='popover' data-content='#{h notice}' data-placement='top'".html_safe
  end

  private

  def balance_html(time, color, icon)
    "<span class='text-#{color}'>
      <i class='fa fa-fw fa-#{icon}-circle'></i>
      #{hour_minute(time)}
    </span>".html_safe
  end
end
