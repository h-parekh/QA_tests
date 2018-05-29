# frozen_string_literal: true

# @see https://downey.io/blog/writing-rubocop-linters-for-database-migrations/ for background in creating
# and implementing custom Rubocop linters
#
# @see http://www.rubydoc.info/gems/rubocop/RuboCop/AST to learn about methods for using Rubocop Node Pattern
module RuboCop
  module Cop
    module Template
      class CustomCop < RuboCop::Cop::Cop
        # This is a template for a custom cop in rubocop. After the template is finished for your specific cop,
        # you need to add it to the top require line in .rubocop.yml for it to be taken into cosideration
        # when rubocop is run.
        #
        # @example
        #    # bad
        #    situation where the cop will throw offense
        #
        # @example
        #    # good
        #    situation where the cop will not throw offense to show how to fix offenses
        #
        MSG = 'Input the message ou want to be provided when this cop flags an offense'

        # Use parser gem to create an Abstract Syntax Tree to identify what sort of node the offense happens in

        def on_block(node)
          node.each_descendant(:node_type) do |node_type|
            method = node_type.method_name
            next unless this_what_i_want_to_test?(method)
            # If the node does not contain what you want to check then next node

            opts = send_node.child_nodes
            # Gives you all the children node for the chosen node to test whether variables, hashing, etc. is correct

            add_offense(send_node, :expression, format(MSG, send_node.type)) unless requirements?(opts)
            # Raise offense on code unless it meets your requirements (included variable is optional and is only need if you are trying to test symbols or parameters for example)
          end
        end

        def method_name(node)
          node.child_nodes[1]
          # This gets the method name in question which you want to test
          # This method will need altering if you are trying to test something other than a method line
          # Research rubocop node pattern to learn how you can test different types of nodes
        end

        def this_what_i_want_to_test?(method)
          method == :scenario
          # This will check to see if the method is a scenario method
          # Can alter this line to test whether it includes a unsafe method, or the case of a method, etc.
        end

        def requirements?(opts)
          opts.each do |child|
            if child.type == :sym && (child.children[0] == :read_only || child.children[0] == :nonprod_only)
              return true
            end
          end
          # This tests the RSpec tags associated with a scenario as these were the requirements
          # Requirements will depend on each cop make sure you define the requirments of passing the rubocop check
        end
      end
    end
  end
end
