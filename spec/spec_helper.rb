require 'ims/lti'
require 'ims/lis'
require 'time'
require 'timecop'
require 'serializable_helpers'
require 'simple_oauth'

def fixture(*file)
  File.new(File.join(File.expand_path("../fixtures", __FILE__), *file))
end

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end
