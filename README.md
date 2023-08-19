# IMS LTI

[![Build Status](https://travis-ci.org/instructure/ims-lti.svg?branch=2.1.x)](https://travis-ci.org/instructure/ims-lti)

LTI ruby implementation

## Installation

Add these lines to your application's Gemfile:

    gem 'ims-lti'
    # only necessary if using ToolProxyRegistrationService:
    gem 'faraday-oauth' # or faraday_middleware if using Faraday < 2.0

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lti

## Usage


### LTI 1.x

#### Validating Launches

You can use the classes in the IMS::LTI::Models::Messages module to valdiate Launches

For example in a rails app you would do the following
```ruby
authenticator = IMS::LTI::Services::MessageAuthenticator.new(request.url, request.request_parameters, shared_secret)

#Check if the signature is valid
return false unless authenticator.valid_signature?

# check if `params['oauth_nonce']` has already been used

#check if the message is too old
return false if DateTime.strptime(request.request_parameters['oauth_timestamp'],'%s') < 5.minutes.ago

```


```ruby

params = { user_id: '123', lti_message_type: IMS::LTI::Models::Messages::BasicLTILaunchRequest::MESSAGE_TYPE }

header = SimpleOAuth::Header.new(:post, 'https://yoursite.com', params, consumer_key: oauth_consumer_key, consumer_secret: secret)

signed_params = header.signed_attributes.merge(params)

IMS::LTI::Services::MessageAuthenticator.new(launch_url, signed_params, secret)

```

## Contributing

1. Fork it ( http://github.com/instructure/ims-lti/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
