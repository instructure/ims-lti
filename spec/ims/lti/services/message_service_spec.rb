require "spec_helper"
module IMS
  module LTI
    module Services
      describe MessageService do
        let(:launch_url) { 'http://www.example.com' }
        let(:params) do
          {
            user_id: '123',
            lti_message_type: IMS::LTI::Models::Messages::BasicLTILaunchRequest::MESSAGE_TYPE
          }
        end
        let(:oauth_consumer_key) { 'key' }
        let (:secret) { 'secret' }
        let (:signed_params) do
          header = SimpleOAuth::Header.new(
            :post,
            launch_url,
            params,
            consumer_key: oauth_consumer_key,
            consumer_secret: secret,
            callback: 'about:blank'
          )
          header.signed_attributes.merge(params)
        end
        let(:message_service) { MessageService.new(launch_url, signed_params) }

        describe '#message' do
          it 'returns a message' do
            expect(message_service.message.lti_message_type).to eq IMS::LTI::Models::Messages::BasicLTILaunchRequest::MESSAGE_TYPE
          end

          it 'contains the launch url' do
            expect(message_service.message.launch_url).to eq(launch_url)
          end
        end


      end
    end
  end
end
