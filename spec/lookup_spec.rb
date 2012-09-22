describe Brain do
	it "Build Lookup" do
		Brain.build_lookup([{a: 1}, {b: 6, c: 7}]).should eql({a:0, b:1, c:2})
	end

end