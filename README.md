# Network Rail Data Feeds Ruby Gem

Provides a convenient Ruby wrapper for the [Network Rail Data Feeds](https://datafeeds.networkrail.co.uk) - a live 'firehose' of real-time data about train timings and movements on the national UK rail network.

## Installation

Add this line to your application's Gemfile:

    gem 'network_rail'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install network_rail

## Pre-Requisites

### Register an account

You must first register an account on the [Network Rail Data Feeds](https://datafeeds.networkrail.co.uk) web site. The user name and password you choose will be used for authenticating with the service via the gem.

The service supports only a limited number of users, so you will need to wait for your account status to change to 'Active' before you can use the gem. You will be e-mailed by Network Rail when this happens.

If you do no access the data feeds for for 30 days, your account may switch to an 'Inactive' state, which will prevent you accessing the feeds.

### Subscribe to feeds

Once you're in, you need to subscribe to feeds on the [Network Rail Data Feeds](https://datafeeds.networkrail.co.uk) web site in order to be able to receive them.

## Quick Start

First set your Network Rail user name and password:
    
    NetworkRail.configure do |config|
      config.user_name = YOUR_EMAIL_ADDRESS
      config.password  = YOUR_PASSWORD
    end

You don't need to supply your security token because this isn't yet used (according to the documentation in the [Developer Pack](http://www.networkrail.co.uk/WorkArea/DownloadAsset.aspx?id=30064782140)).

The gem implements a Stomp client to allow you to consume the data feeds, and parses each messages into a convenient Ruby object. Once the client is loaded, it will continue listening for new messages until you tell it to stop.

### Starting the client

You need to load the client to establish the connection between yourself and the feed provider. Create a new instance of the client as below.

    client = NetworkRail::Client.new
    
### Subscribing to feeds

Each client can listen to one or more data feeds. You need to specify a feed to begin receiving data. For example:

    client.train_movements(operator: :all) do |movement|
      # Do something
    end

Messages will begin to arrive from Network Rail in batches every few seconds. In the above example, `movement` will be an instance of a subclass of `NetworkRail::Message::TrainMovement` (e.g. `NetworkRail::Message::TrainMovement::Arrival`). Some of the cool things you can do with this object are:

- Check if the train arrived on time with `movement.on_time?`
- Get the delay (if any) with `movement.delay`
- Determine the next station the train is due to stop at with `movement.next_station`

You can set the threshold at which a train is considered 'late' in the gem configuration.

## Threading

The client runs on a separate thread, so once you've subscribed to all your feeds you need to ensure execution of your script doesn't end immediately. This can be most easily accomplished with something like this:

    while true
      # Continue forever
    end

Add your own control logic if you need to do anything more complicated.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

This gem is created by Steven Lorek and is under the MIT License.
