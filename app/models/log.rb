# 
# Keep record of requests and results.
# 
class Log < ApplicationRecord
	
	scope :recent_logs, -> { order( 'created_at DESC').limit(100) }
	
	
	# Write a Log record.
	def self.write request, result, label="exact"
		o = Log.new
		o.request = request
		o.result = result
		o.label = label
		o.save
	end
	
end
