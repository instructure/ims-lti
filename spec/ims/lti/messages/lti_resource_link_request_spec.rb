module Ims::Lti::Messages
  RSpec.describe LtiResourceLinkRequest do
    let(:message) { LtiResourceLinkRequest.new }

    describe 'initialize' do
      it 'allows attribute initialization with a hash' do
        expect(LtiResourceLinkRequest.new(
          family_name: 'Baggins'
        ).family_name).to eq 'Baggins'
      end

      it 'defaults message_type to "LtiResourceLinkRequest"' do
        expect(message.message_type).to eq 'LtiResourceLinkRequest'
      end

      it 'defaults version to "1.3.0"' do
        expect(message.version).to eq '1.3.0'
      end
    end

    describe 'validations' do
      it 'is not valid if required claims are missing' do
        expect(message).to be_invalid
      end

      it 'is valid if all required claims are present' do
        expect(
          LtiResourceLinkRequest.new(
            aud: ['129aeb8c-a267-4551-bb5f-e6fc308fcecf'],
            azp: '163440e5-1c75-4c28-a07c-43e8a9cd3110',
            sub: '7da708b6-b6cf-483b-b899-11831c685b6f',
            deployment_id: 'ee493d2e-9f2e-4eca-b2a0-122413887caa',
            iat: 1529681618,
            exp: 1529681634,
            iss: 'https://platform.example.edu',
            nonce: '5a234202-6f0e-413d-8793-809db7a95930',
            resource_link: Ims::Lti::Claims::ResourceLink.new(id: '1')
          )
        ).to be_valid
      end

      it 'verifies that "aud" is an array' do
        message.aud = 'invalid-claim'
        message.validate
        expect(message.errors.messages[:aud]).to match_array [
          'aud must be an intance of Array'
        ]
      end

      it 'verifies that "context" is a Context claim' do
        message.context = 'invalid-claim'
        message.validate
        expect(message.errors.messages[:context]).to match_array [
          'context must be an intance of Ims::Lti::Claims::Context'
        ]
      end

      it 'verifies that "extensions" is an array' do
        message.extensions = 'invalid-claim'
        message.validate
        expect(message.errors.messages[:extensions]).to match_array [
          'extensions must be an intance of Array'
        ]
      end

      it 'verifies that "launch_presentation" is a LaunchPresentation claim' do
        message.launch_presentation = 'invalid-claim'
        message.validate
        expect(message.errors.messages[:launch_presentation]).to match_array [
          'launch_presentation must be an intance of Ims::Lti::Claims::LaunchPresentation'
        ]
      end

      it 'verifies that "lis" is a Lis claim' do
        message.lis = 'invalid-claim'
        message.validate
        expect(message.errors.messages[:lis]).to match_array [
          'lis must be an intance of Ims::Lti::Claims::Lis'
        ]
      end

      it 'verifies that "platform" is a Platform claim' do
        message.platform = 'invalid-claim'
        message.validate
        expect(message.errors.messages[:platform]).to match_array [
          'platform must be an intance of Ims::Lti::Claims::Platform'
        ]
      end

      it 'verifies that "resource_link" is a ResourceLink claim' do
        message.resource_link = 'invalid-claim'
        message.validate
        expect(message.errors.messages[:resource_link]).to match_array [
          'resource_link must be an intance of Ims::Lti::Claims::ResourceLink'
        ]
      end

      it 'verifies that "roles" is an array' do
        message.roles = 'invalid-claim'
        message.validate
        expect(message.errors.messages[:roles]).to match_array [
          'roles must be an intance of Array'
        ]
      end

      it 'verifies that "role_scope_mentor" is an array' do
        message.role_scope_mentor = 'invalid-claim'
        message.validate
        expect(message.errors.messages[:role_scope_mentor]).to match_array [
          'role_scope_mentor must be an intance of Array'
        ]
      end
    end
  end
end