require 'spec_helper'

module IMS::LTI::Services
  describe OAuth1Client do
    let(:base_url) { 'http://www.base.com' }
    let(:consumer_key) { 'consumer_key' }
    let(:shared_secret) { 'shared_secret' }
    let(:client) { OAuth1Client.new(consumer_key: consumer_key, consumer_secret: shared_secret) }

    describe '#connection' do
      it 'adds the oauth_body_hash' do
        stub_request(:post, "http://example.com/test").
          with(:body => "{\"test\": 1}",
               :headers => {'Authorization'=> /.*oauth_body_hash="RRzk9s6ONZotEFfCwllq2Bo52jo%3D".*/})

        client.connection.post('http://example.com/test', '{"test": 1}', {'Content-Type': 'application/json'})
      end

      it 'adds the consumer_key' do
        stub_request(:post, "http://example.com/test").
          with(:body => "{\"test\": 1}",
               :headers => {'Authorization'=> /.*oauth_consumer_key="consumer_key".*/})

        client.connection.post('http://example.com/test', '{"test": 1}', {'Content-Type': 'application/json'})
      end

    end
  end
end