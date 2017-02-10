# IMS LTI

[![Build Status](https://travis-ci.org/instructure/ims-lti.svg?branch=2.0.x)](https://travis-ci.org/instructure/ims-lti)

#Version 2.x is currently BETA

LTI ruby implementation

## Installation

Add this line to your application's Gemfile:

    gem 'lti'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lti

## Usage


### LTI 1.x

#### Validating Launches

You can use the IMS::LTI::Services::MessageAuthenticator to validate launches

For example in a rails app you would do the following
```ruby
authenticator = IMS::LTI::Services::MessageAuthenticator.new(request.url, request.request_parameters, shared_secret)

#Check if the signature is valid
return false unless authenticator.valid_signature?

# check if `params['oauth_nonce']` has already been used

#check if the message is too old
return false if DateTime.strptime(request.request_parameters['oauth_timestamp'],'%s') > 5.minutes.ago

```

## Contributing

1. Fork it ( http://github.com/instructure/lti/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
