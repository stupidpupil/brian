module Brian
	module Lookup
		def self.build_lookup(hashes)
			hash = hashes.reduce do |memo, hash|
				memo.merge(hash)
			end

			return Brian::Lookup.lookup_from_hash(hash)
		end

		def self.lookup_from_hash(hash)
			lookup = {}
			index = 0

			hash.keys.each do |k|
				lookup[k] = index
				index += 1
			end

			return lookup
		end

		def self.to_array(lookup, hash)
			array = []

			lookup.each_pair do |k,v|
				array[v] = hash.has_key?(k) ? hash[k] : 0
			end

			return array
		end

		def self.to_hash(lookup, array)
			hash = {}

			lookup.each_pair do |k,v|
				hash[k] = array[v]
			end

			return hash
		end
	end
end 