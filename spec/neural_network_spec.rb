require 'brian'

describe Brian::NeuralNetwork do
	describe "Can learn XOR" do

		before do
			@net = Brian::NeuralNetwork.new
			@net.train([
				{input: [0, 0], output: [0]},
				{input: [0, 1], output: [1]},
				{input: [1, 0], output: [1]},
				{input: [1, 1], output: [0]}])
		end

		it "[1,0] => [1]" do
			@net.run([1, 0]).map {|x| x.round}.should eql([1])
		end


		it "[1,1] => [0]" do
			@net.run([1, 1]).map {|x| x.round}.should eql([0])
		end

		it "[0,0] => [0]" do
			@net.run([0, 0]).map {|x| x.round}.should eql([0])
		end
	end

	describe "Can learn the Colour Contrast demo" do

		before do
			@net = Brian::NeuralNetwork.new
			@net.train([
				{input: { r: 0.03, g: 0.7, b: 0.5 }, output: { black: 1.0 }},
	           	{input: { r: 0.16, g: 0.09, b: 0.2 }, output: { white: 1.0 }},
    	       	{input: { r: 0.5, g: 0.5, b: 1.0 }, output: { white: 1.0 }}])
		end

		it "{r:1,g:0.4,b:0} => White" do
		 	result = @net.run({ r: 1, g: 0.4, b: 0 })
		 	result[:white].round.should eql(1)
		 	result[:black].round.should eql(0)
		end

	end

end