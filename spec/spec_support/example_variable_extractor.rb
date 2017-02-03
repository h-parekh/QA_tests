ExampleVariable = Struct.new(:application_name_under_test, :test_type)

module ExampleVariableExtractor
  # @param path [String] The path to the spec file that is being tested
  # @return [ExampleStruct] An object that responds to #application_name_under_test and #test_type
  # @note If we start nesting our specs, this may need to be revisited.
  def self.call(path:)
    path_to_spec_directory = File.expand_path('../../', __FILE__)
    spec_sub_directory = path.sub("#{path_to_spec_directory}/", '').split('/')
    application_name_under_test = spec_sub_directory[0]
    test_type = spec_sub_directory[1]
    ExampleVariable.new(application_name_under_test, test_type)
  end
end
