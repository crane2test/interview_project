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

	# Get the population for a particular year.
	# NOTE that if there's no data for a given year, 
	# we're going to extrapolate.
  def self.get(year)
    year = year.to_i

    return 0 if year < min_year

    pop = find_closest_year( year )
    return pop.population if pop

    nil
  end

end
