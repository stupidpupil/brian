require 'brain'

describe Brain::Lookup do
	it "Build Lookup" do
		Brain::Lookup.build_lookup([{a: 1}, {b: 6, c: 7}]).should eql({a:0, b:1, c:2})
	end

	it "Lookup from Hash" do
		Brain::Lookup.lookup_from_hash({a: 6, b: 7}).should eql({a:0, b:1})
	end

	it "Hash to Array" do 
		Brain::Lookup.to_array({a: 0, b: 1}, {a: 6}).should eql([6,0])
	end

	it "Array to Hash" do 
		Brain::Lookup.to_hash({a: 0, b: 1}, [6, 7]).should eql({a: 6, b: 7})
	end
end