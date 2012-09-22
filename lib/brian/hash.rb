module Brian
	class NeuralNetwork

		def to_hash
			layers = []
			@sizes.count.times do |layer|
				layers[layer] = {}

				if layer == 0 and @input_lookup
					nodes = @input_lookup.keys
				elsif (layer == @output_layer) and @output_lookup
					nodes = @output_lookup.keys
				else
					nodes = (0..@sizes[layer]-1).to_a
				end


				nodes.each_with_index do |node,j|
					layers[layer][node] = {}

					next if layer == 0
					layers[layer][node][:bias] = @biases[layer][j]

					layers[layer][node][:weights] = {}

					layers[layer-1].keys.each do |k|
						index = k
						index = @input_lookup[k] if (layer == 1) and @input_lookup
						
						layers[layer][node][:weights][k] = @weights[layer][j][index]	
					end
				end
			end

			return {layers:layers}
		end

		def self.new_with_hash(hash)
			net = NeuralNetwork.new

			net.instance_eval do
				size = hash[:layers].count
				@output_layer = size -1

				@sizes = Array.new(size)
				@weights = Array.new(size)
				@biases = Array.new(size)
				@outputs = Array.new(size)

				hash[:layers].each_with_index do |layer, i|
					if i == 0 and layer[0].nil?
						@input_lookup = Brian::Lookup.lookup_from_hash(layer)
					end

					if i == @output_layer and layer[0].nil?
						@output_lookup = Brian::Lookup.lookup_from_hash(layer)
					end

					nodes = layer.keys

					@sizes[i] = nodes.count
					@weights[i] = []
					@biases[i] = []
					@outputs[i] = []

					nodes.each_with_index do |node, j|
						@biases[i][j] = layer[node][:bias]
						@weights[i][j] = layer[node][:weights].nil? ? nil : layer[node][:weights].values
					end
				end

			end
			return net
		end

	end
end