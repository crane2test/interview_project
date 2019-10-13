require 'rails_helper'

RSpec.describe Population, type: :model do

  it "should accept a year we know and return the correct population" do
    expect(Population.get(1900)).to eq(76212168)
    expect(Population.get(1990)).to eq(248709873)
  end

  it "should accept a year we don't know and return the previous known population" do
    expect(Population.get(1902)).to eq(76212168)
    expect(Population.get(1908)).to eq(76212168)
  end

  it "should accept a year that is before earliest known and return zero" do
    expect(Population.get(1800)).to eq(0)
    expect(Population.get(0)).to eq(0)
    expect(Population.get(-1000)).to eq(0)
  end

  it "should accept a year that is after latest known and return the last known population" do
    expect(Population.get(2000)).to eq(248709873)
    expect(Population.get(200000)).to eq(248709873)
  end
	
	it "should extrapolate for missing data" do
		a = 151325798
		b = 179323175
		c = 165324487
		y1 = 1950
		y2 = 1960
		expect(Population.get(y1)).to eq(a)
		expect(Population.get(y2)).to eq(b)
		
		y = 1955
		factor = ( y - y1 ).to_f / ( y2 - y1 ).to_f
		expect( factor ).to eq( 0.5 )
		x = ( a + ( ( b - a ) * factor ) ).round
		expect( x ).to eq( c )
		expect(Population.get(y,true)).to eq(x)
	end
	
	it "should know if it is the same year" do
		o = Population.new
		o.year = Date.parse( "1/1/2000" )
		expect( o.is_year?( 2000 ) ).to be true
		expect( o.is_year?( 2001 ) ).to be false
		expect( o.is_year?( 1999 ) ).to be false
	end

	it "should grow exponentially for future years" do
		expect(Population.get(1990)).to eq(248709873)
		expect(Population.get(1991)).to eq(248709873)
		x = ( Population.get(1991) * 1.09 ).round
		expect(Population.get(1991,true)).to eq(x)

		x = ( Population.get(1990) * 1.09 * 1.09 ).round
		expect(Population.get(1992,true)).to eq(x)
	end

	it "should be out of range if given year is past 2500" do
		expect(Population.get(2501,true)).to eq("Out of Range")		
	end
	
end
