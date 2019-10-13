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
	
	# Find the extrapolated population value when we don't have 
	# an exact data match.
	def self.get_extrapolated_pop( given_year, found_year )
		next_year = find_next_year( given_year )
		return found_year.population unless next_year
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

	# Get the population for a particular year.
	# NOTE that if there's no data for a given year, 
	# we're going to extrapolate.
  def self.get(year, extrapolate=false)
    year = year.to_i
    return 0 if year < min_year

    pop = find_closest_year( year )
		if pop 
			return pop.population unless extrapolate
			return pop.population if pop.is_year?( year )

			return get_extrapolated_pop( year, pop )
		end
		
    nil
  end

	# Is this the same year?
	def is_year? y
		return year.year == y.to_i
	end

end
