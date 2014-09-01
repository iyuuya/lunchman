module Validators; end
Dir.glob(Rails.root.join('lib/validators/*.rb')).each { |lib| require lib }
