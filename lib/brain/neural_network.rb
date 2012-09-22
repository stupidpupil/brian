module Brain
	class NeuralNetwork

		def self.random_weight
			rand()*0.4 - 0.2
		end

		def self.mse(errors)
			errors.map {|e| e**2}.inject(:+)/errors.length
		end

		def initialize
			@learning_rate = 0.3
			@momentum = 0.1
		end


		def initialize_layers(sizes)
			@sizes = sizes
			@output_layer = @sizes.length - 1

			@biases = []
			@weights = []
			@outputs = []

			@deltas = []
			@changes = []
			@errors = []

			@sizes.length.times do |layer|
				size = @sizes[layer]

				@deltas[layer] = Array.new(size) {0}
				@errors[layer] = Array.new(size) {0}
				@outputs[layer] = Array.new(size) {0}

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

		def run(input)
			input = Brain::Lookup.to_array(@input_lookup, input) if @input_lookup

			output = self.run_input(input)

			output = Brain::Lookup.to_hash(@output_lookup, output) if @output_lookup

			return output
		end

		def run_input(input)
			@outputs[0] = input

			@output_layer.times do |layer|
				layer += 1
				@sizes[layer].times do |node|
					weights = @weights[layer][node]
					sum = @biases[layer][node]

					weights.each_with_index {|w,k| sum += w*input[k]}
					
					@outputs[layer][node] = 1.0 / (1.0 + Math.exp(-sum))
				end

				input = @outputs[layer]
			end


			return @outputs[@output_layer]
		end

		def format_data(data)
			if not data[0][:input].is_a?(Array)
				if @input_lookup.nil?
					inputs = data.map {|d| d[:input]}
					@input_lookup = Brain::Lookup.build_lookup(inputs)
				end

				data.each do |d|
					d[:input] = Brain::Lookup.to_array(@input_lookup,d[:input])
				end
			end

			if not data[0][:output].is_a?(Array)
				if @output_lookup.nil?
					inputs = data.map {|d| d[:output]}
					@output_lookup = Brain::Lookup.build_lookup(inputs)
				end

				data.each do |d|
					d[:output] = Brain::Lookup.to_array(@output_lookup,d[:output])
				end
			end

			return data
		end

		def train(data, options = {})
			data = self.format_data(data)

			options = ({
				iterations:20000,
				error_thresh:0.005,
				log:false,
				log_period:10,
				callback_period:10
			}).merge(options)

			input_size = data[0][:input].size
			output_size = data[0][:output].size
			
			hidden_sizes = @hidden_sizes

			if hidden_sizes.nil?
				hidden_sizes = [[3,(input_size.to_f/2).floor].max]
			end

			sizes = [input_size,hidden_sizes,output_size].flatten
			self.initialize_layers(sizes)

			error = 1

			i = 0
			options[:iterations].times do |i|
				sum = 0

				data.each do |d|
					err = self.train_pattern(d[:input],d[:output])
					sum += err
				end

				error = sum/data.count

				if options[:log] and (i % options[:log_period] == 0)
					puts "iterations:#{i} training_error #{error}"
				end

				if options[:callback] and (i % options[:callback_period] == 0)
					options[:callback].call({error:error, iterations:i})
				end

				break if error <= options[:error_thresh]
			end

			return {error:error, iterations:i}
		end


		def train_pattern(input, target)
			#Forward propogate
			self.run_input(input)

			#Back propogate
			self.calculate_deltas(target)
			self.adjust_weights()

			error = Brain::NeuralNetwork.mse(@errors[@output_layer])

			return error
		end

		def calculate_deltas(target)
			@sizes.length.times do |layer|
				layer = -(layer+1)
				@sizes[layer].times do |node|
					output = @outputs[layer][node]
					error = 0

					if layer == -1 #Output layer
						error = (target[node] - output).to_f
					else
						deltas = @deltas[layer+1]
						deltas.each_with_index do |d,k|
							error += d * @weights[layer+1][k][node]
						end
					end

					@errors[layer][node] = error
					@deltas[layer][node] = error*output*(1.0-output)
				end
			end
		end

		def adjust_weights
			@output_layer.times do |layer|
				layer += 1
				incoming = @outputs[layer-1]

				@sizes[layer].times do |node|
					delta = @deltas[layer][node]

					incoming.each_with_index do |i,k|
						change = @changes[layer][node][k]

						change *= @momentum
						change += @learning_rate * delta * i

						@changes[layer][node][k] = change
						@weights[layer][node][k] += change
					end

					@biases[layer][node] += @learning_rate * delta
				end
			end
		end

	end
end