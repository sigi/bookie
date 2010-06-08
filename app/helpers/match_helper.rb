module MatchHelper

  def display(match, options = {})
    return "&mdash;" unless match
    "<b>" + ( match.team1.name ) + "&nbsp;&ndash;&nbsp;" + ( match.team2.name ) + "</b>" +
            ( options[:include_date] ? "<br/>#{date_string(match)}" : "" )
  end

  def date_string(match)
    match.date.strftime( "%d.%m. um %H:%M&nbsp;Uhr" )
  end

end
