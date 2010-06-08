class DivisionsController < ApplicationController

  before_filter :require_admin
  active_scaffold

end
