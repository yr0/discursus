module ApplicationHelper
  START_YEAR = 2016

  def years_active
    [START_YEAR, Time.zone.now.year].uniq.join('&ndash;').html_safe
  end
end
