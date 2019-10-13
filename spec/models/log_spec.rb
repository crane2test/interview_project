require 'rails_helper'

RSpec.describe Log, type: :model do
	
	it "should write a new record" do
		expect { Log.write( 'x', 'y' ) }.to change { Log.count }.by(1)
	end
  
end
