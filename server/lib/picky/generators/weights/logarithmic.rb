module Picky

  module Generators

    module Weights

      # Uses a logarithmic weight.
      # If for a key k we have x ids, the weight is:
      # w(x): log(x)
      # Special case: If x < 1, then we use 0.
      #
      class Logarithmic < Strategy

        # Sets the weight value.
        #
        # If the size is 0 or one, we would get -Infinity or 0.0.
        # Thus we do not set a value if there is just one. The default, dynamically, is 0.
        #
        # BUT: We need the value, even if 0. To designate that there IS a weight!
        #
        def weight_for amount
          return 0 if amount < 1
          Math.log(amount).round 3
        end

      end

    end

  end

end