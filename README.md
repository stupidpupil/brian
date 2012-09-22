# brain

`brain` is a Ruby port of a [neural network](http://en.wikipedia.org/wiki/Artificial_neural_network) library, implementing a [multilayer perceptron](http://en.wikipedia.org/wiki/Multilayer_perceptron). The JavaScript library that it is based on can be found [here](https://github.com/harthur/brain). 

Here's an example of using it to approximate the XOR function:
```ruby
net = Brain::NeuralNetwork.new

net.train([{input: [0, 0], output: [0]},
		   {input: [0, 1], output: [1]},
		   {input: [1, 0], output: [1]},
		   {input: [1, 1], output: [0]}])

output = net.run([1, 0]) # => [0.931]
```

The author of the orignal JavaScript library provides a more involved, realistic example of using a perceptron:
[Demo: training a neural network to recognize color contrast](http://harthur.github.com/brain/)


# Training
Use `train()` to train the network with an array of training data. The network has to be trained with all the data in bulk in one call to `train()`. The more training patterns, the longer it will take to train, but the better the network will be at classifiying new patterns.

## Data format
Each training pattern should have an `input` and an `output`, both of which can be either an array of numbers from `0` to `1` or a hash of numbers from `0` to `1`. For a Ruby port of the [color constrast demo](http://harthur.github.com/brain/) it would like something like this:

```ruby
net = Brain::NeuralNetwork.new

net.train([{input: { r: 0.03, g: 0.7, b: 0.5 }, output: { black: 1.0 }},
	       {input: { r: 0.16, g: 0.09, b: 0.2 }, output: { white: 1.0 }},
    	   {input: { r: 0.5, g: 0.5, b: 1.0 }, output: { white: 1.0 }}])

output = net.run({ r: 1, g: 0.4, b: 0 }) # => {:black=>0.024, :white=>0.976}
````

## Options
`train()` takes a hash of options as its second argument:

```ruby
net.train(data, {
  error_thresh: 0.004,  # error threshold to reach
  iterations: 20000,    # maximum training iterations
  log: true,            # puts progress periodically
  log_period: 10        # number of iterations between logging
})
```

The network will train until the training error has gone below the threshold (default `0.004`) or the max number of iterations (default `20000`) has been reached, whichever comes first.

By default training won't let you know how its doing until the end, but set `log` to `true` to get periodic updates on the current training error of the network. The training error should decrease every time.

## Output
The ouput of `train()` is a hash of information about how the training went:

```ruby
{
  error: 0.0039139985510105032,  // training error
  iterations: 406                // training iterations
}
```

# Serialisation

The states of trained networks can be stored with `#to_hash` and retrieved with `::new_with_hash`:

```ruby

net = Brain::NeuralNetwork.new
net.train(data)

saved_state = net.to_hash

#...

net = Brain::NeuralNetwork.new_with_hash(saved_state)
```

## JSON

Calling `#to_json` on the Hash produced by `#to_hash` should produce JSON compatible with [the original JavaScript library](https://github.com/harthur/brain):

```ruby
require 'json'

net = Brain::NeuralNetwork.new
net.train(data)

net_json = net.to_hash.to_json => "{\"layers\":...
```

# Licensing

In coherence with the licensing of the JavaScript `brain` library, this gem is licensed under the MIT license (Expat).