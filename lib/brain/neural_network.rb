module Brain
	class NeuralNetwork

		def self.random_weight
			rand()*0.4 - 0.2
		end


		def initialize_layers(sizes)
			@sizes = sizes
			@output_layer = @sizes.length - 1

			@biases = []
			@weights = []
			@outpus = []

			@deltas = []
			@changes = []
			@errors = []

			@output_layer.times do |layer|
				size = @sizes[layer]

				@deltas[layer] = Array.new(size) {0}
				@errors[layer] = Array.new(size) {0}
				@output[layer] = Array.new(size) {0}

				next if layer == 0

				@biases[layer] = Array.new(size) {NeuralNetwork.random_weight}
				@weights[layer] = Array.new(size)
				@changes[layer] = Array.new(size)

				size.times do |node|
					prev_size = @sizes[layer - 1]
					@weights[layer][node] = Array.new(prev_size) {NeuralNetwork.random_weight}
					@changes[layer][node] = Array.new(prev_size) {0}

				end
			end
		end


	end
end