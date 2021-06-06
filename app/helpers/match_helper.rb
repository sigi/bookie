module MatchHelper

  def display(match, options = {})
    if match
      "<b>" + ( match.team1.name ) + "&nbsp;&ndash;&nbsp;" + ( match.team2.name ) + "</b>" +
        ( options[:include_date] ? "<br/>#{date_string(match)}" : "" )
    else
      "&mdash;"
    end.html_safe
  end

  def date_string(match)
    match.date.strftime( "%d.%m. um %H:%M&nbsp;Uhr" ).html_safe
  end

end
