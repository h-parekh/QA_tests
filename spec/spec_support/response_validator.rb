# frozen_string_literal: true
# This class provides a consolidation for validating responses from an API test

class ResponseValidator
  def initialize(operation, result)
    @current_operation = operation
    @current_result = result
  end

  def valid_response?
    status_response_ok? &&
      valid_schema?
  end

  def status_response_ok?
    @current_result.code.to_s == @current_operation.responses.keys[0]
  end

  def valid_schema?
    ## Snippet below is a workaround to the resolve_refs method.
    # Get the schema for key[0]
    response_schema = @current_operation.responses.values[0]
    # Gets the response $ref
    key_ref = response_schema.schema.values[0]
    # Seperates the $ref from path format to get specific $ref
    ref=key_ref.split('#/definitions/').join
    # Resolve definition references
    resolved_schema = response_schema.schema.root.definitions
    # Resolve definition properties
    schema_properties = resolved_schema.fetch("#{ref}").properties.keys
    # Parse result body as JSON and find the keys
    result_keys = JSON.parse(@current_result.body).keys
    # Making sure all the properties listed in Swagger definition
    # are present in the result body
    (schema_properties & result_keys).sort == schema_properties.sort
  end
end
