# 
# Log controller gives visibility into application usage.
# 
class LogsController < ApplicationController
	
  def index
		@logs = Log.recent_logs
  end

end
