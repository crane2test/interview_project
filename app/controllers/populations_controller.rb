class PopulationsController < ApplicationController
  def index
  end

  def show
    @year = params[:year].html_safe
		
		# Convert to integer to prevent nasties in URL parameters
		@year = @year.to_i.to_s
		
    @population = Population.get(@year,true)
		Log.write( @year, @population )
  end
end
