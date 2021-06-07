class TeamsController < ApplicationController

  before_action :require_admin
  active_scaffold

end
