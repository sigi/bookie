# vim: fileencoding=utf-8
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def result_string( match )
    result1, result2 = match.result1, match.result2
    if( not result1.blank? and not result2.blank? )
      "#{result1}:#{result2}"
    else
      "?"
    end
  end

  def current_time
    Time.now.strftime( "%d.%m, %H:%M Uhr" )
  end

  IMAGES = {
    :show => [ 'Anzeigen', 'b_browse.png' ],
    :edit => [ 'Bearbeiten', 'b_edit.png' ],
    :delete => [ 'Löschen', 'b_drop.png' ]
  }

  def images( type )
    image_tag( IMAGES[type][1], :alt => IMAGES[type][0] )
  end

  def all_divisions
    Division
      .all
      .order('id ASC')
  end

  def cur_link( string )
    "<span class=\"current\">#{string}</span>".html_safe
  end

  def merge_uid( hash )
    if @query_user != current_user
      hash[:uid] = @query_user.id
    end
    hash
  end

  def link_to_user( user )
    link_to( user.real_name, { :controller => 'bets', :action => 'last', :id => 4, :uid => user.id },
             { :class => 'uid_link' } )
  end

  def hof_linker( hof, crit )
    (hof[crit].map { |h| link_to_user h[:user] }.join ', ').html_safe
  end

end
