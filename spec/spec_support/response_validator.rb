# frozen_string_literal: true
# This class provides a consolidation for validating responses from an API test

class ResponseValidator
  def initialize(operation, result)
    @current_operation = operation
    @current_result = result
  end

  def valid_response?
    return true if @current_result.request.method == 'options'
    status_response_ok? &&
      valid_schema?
  end

  def status_response_ok?
    @current_result.code.to_s == @current_operation.responses.keys[0]
  end

  def valid_schema?
    # Making sure all the properties listed in Swagger definition
    # are present in the result body
    result_keys = get_result_keys.sort
    schema_properties = get_schema_properties.sort
    (result_keys & schema_properties).sort == schema_properties.sort
  end

  def get_result_keys
    # Parse result body as JSON and find the keys
    result_keys = JSON.parse(@current_result.body).keys
    # finds the deeper level results keys for each key
    result_keys.each do |key|
      # if the class is not an array, it means there are no more keys at that level
      if JSON.parse(@current_result.body)[key].class == Array
        # adds the deeper level result keys to the result_keys list
        result_keys += JSON.parse(@current_result.body)[key][0].keys
      end
    end
    return result_keys
  end

  def get_schema_properties
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
    schema_properties.each do |property|
      # needed to identify if items property exists
      definition_ref = resolved_schema.fetch("#{ref}").properties[property]
      # if items key exists it needs to be used
      if definition_ref.keys.include?('items')
        key_ref = definition_ref.items.values[0]
        ref = key_ref.split('#/definitions/').join
        schema_properties += resolved_schema.fetch("#{ref}").properties.keys
      # else use conventional way
      elsif resolved_schema.fetch("#{ref}").properties.values[0].keys.include?('$ref')
        # gets the keys from deeper level $ref path
        key_ref = resolved_schema.fetch("#{ref}").properties.values[0].values[0]
        # turns the $ref path into a specfic $ref
        ref = key_ref.split('#/definitions/').join
        # adds the keys from deeper level schema
        schema_properties += resolved_schema.fetch("#{ref}").properties.keys
      end
    end
    return schema_properties
  end
end
