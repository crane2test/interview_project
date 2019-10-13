# 
# Log controller gives visibility into application usage.
# 
class LogsController < ApplicationController
	
  def index
		@logs = Log.recent_logs
		
		@years = Population.select( 'year', 'count(request)' ).left_outer_joins( :logs ).group( 'year' ).all
  end

end
