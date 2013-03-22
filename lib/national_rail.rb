require "stomp"
require "national_rail/client"
require "national_rail/configuration"
require "national_rail/version"
require "national_rail/exception/authentication_error"
require "national_rail/exception/connection_error"
require "national_rail/exception/no_login_credentials"

module NationalRail
  extend Configuration
end
