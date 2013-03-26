require 'network_rail'

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.read(fixture_path + '/' + file)
end