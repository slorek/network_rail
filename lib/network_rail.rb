require "stomp"
require "json"
require "network_rail/client"
require "network_rail/configuration"
require "network_rail/version"
require "network_rail/exception/authentication_error"
require "network_rail/exception/block_required"
require "network_rail/exception/connection_error"
require "network_rail/exception/no_login_credentials"
require "network_rail/message/train_movement"

module NetworkRail
  extend Configuration
end
