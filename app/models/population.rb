class Population < ApplicationRecord

  def self.min_year
    Population.all.map(&:year).min.year
  end
	
	# Look for the closest year for which we have data.
	# The closest year might be the year requested, 
	# or it might be an earlier year.
	def self.find_closest_year( year )
		d = Date.new( year )
		return Population.where( 'year <= ?', d ).order( 'year DESC' ).first
	end

	# Find the next year after the given one.
	def self.find_next_year( year )
		d = Date.new( year )
		return Population.where( 'year > ?', d ).order( 'year ASC' ).first
	end
	
	# Calculate exponential growth for a future date.
	# Assume a 9% growth rate
	def self.future_growth( given_year, found_year )
		given_year = given_year.to_i
		return "Out of Range" if given_year > 2500
		years = given_year - found_year.year.year
		factor = ( 1.09 ** years )
		future = ( found_year.population * factor ).round
		return future
	end
	
	# Find population between two known years.
	def self.between_years( given_year, found_year, next_year )
		a = found_year.population
		b = next_year.population
		c = 165324487
		y1 = found_year.year.year
		y2 = next_year.year.year
	
		y = given_year
		factor = ( y - y1 ).to_f / ( y2 - y1 ).to_f
		x = ( a + ( ( b - a ) * factor ) ).round
		return x
	end
	
	# Find the extrapolated population value when we don't have 
	# an exact data match.
	def self.get_extrapolated_pop( given_year, found_year )
		next_year = find_next_year( given_year )
		if next_year
			return between_years( given_year, found_year, next_year )
		else
			return future_growth( given_year, found_year )
		end
	end

	# Get the population for a particular year.
	# NOTE that if there's no data for a given year, 
	# we're going to extrapolate.
  def self.get(year, extrapolate=false)
    year = year.to_i
    return 0 if year < min_year

    pop = find_closest_year( year )
		if pop 
			if ( extrapolate == false ) || ( pop.is_year?( year ) )
				Log.write( year, pop.population )
				return pop.population
			end

			calculated = get_extrapolated_pop( year, pop )
			Log.write( year, calculated, "calculated" )
			return calculated
		end
		
    nil
  end

	# Is this the same year?
	def is_year? y
		return year.year == y.to_i
	end

end
