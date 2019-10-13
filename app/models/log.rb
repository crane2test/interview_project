# 
# Keep record of requests and results.
# 
class Log < ApplicationRecord
	
	belongs_to :population, :optional => true
	
	scope :recent_logs, -> { order( 'created_at DESC').limit(100) }
	
	
	# Write a Log record.
	def self.write request, result, label, population=nil
		o = Log.new
		o.request = request
		o.result = result
		o.label = label
		o.population = population
		o.save
	end
	
end
