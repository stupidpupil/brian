require 'brian'

describe Brian::NeuralNetwork do
	describe "Can store and retrieve XOR-network" do
		before do
			@net = Brian::NeuralNetwork.new
			@net.train([
				{input: [0, 0], output: [0]},
				{input: [0, 1], output: [1]},
				{input: [1, 0], output: [1]},
				{input: [1, 1], output: [0]}])
		end

		it "Produces identical output" do 
			net2 = Brian::NeuralNetwork.new_with_hash(@net.to_hash)

			input = [1,0]
			@net.run(input).should eql net2.run(input)
		end
	end

	describe "Can store and retrieve the Colour Contrast-network" do
		before do
			@net = Brian::NeuralNetwork.new
			@net.train([
				{input: { r: 0.03, g: 0.7, b: 0.5 }, output: { black: 1.0 }},
	           	{input: { r: 0.16, g: 0.09, b: 0.2 }, output: { white: 1.0 }},
    	       	{input: { r: 0.5, g: 0.5, b: 1.0 }, output: { white: 1.0 }}])
		end


		it "Produces identical output" do 
			net2 = Brian::NeuralNetwork.new_with_hash(@net.to_hash)

			input = { r: 1, g: 0.4, b: 0 }
			@net.run(input).should eql net2.run(input)
		end

	end
end