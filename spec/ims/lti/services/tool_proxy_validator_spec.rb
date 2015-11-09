require 'spec_helper'

module IMS::LTI::Services
  describe ToolProxyValidator do

    let(:tool_proxy) do
      IMS::LTI::Models::ToolProxy.from_json(fixture('models/tool_proxy.json').read)
    end
    let(:tool_consumer_profile) do
      IMS::LTI::Models::ToolConsumerProfile.from_json(fixture('models/tool_consumer_profile.json').read)
    end
    let(:faraday) { double }

    before(:each) do
      allow(Faraday).to receive(:new) { faraday }
    end

    subject do
      subj = described_class.new(tool_proxy)
      subj.tool_consumer_profile = tool_consumer_profile
      subj
    end

    describe "#tool_consumer_profile" do
      it 'tries to download the tool consumer profile' do
        subject.instance_variable_set(:@tool_consumer_profile, nil)
        expect(faraday).to receive(:get).with('http://lms.example.com/profile/b6ffa601-ce1d-4549-9ccf-145670a964d4') { double(body: '{"id": "profile_id"}') }
        tcp = subject.tool_consumer_profile
        expect(tcp).to be_a IMS::LTI::Models::ToolConsumerProfile
        expect(tcp.id).to eq 'profile_id'
      end

      it 'memoizes the tool_consumer_profile' do
        subject.instance_variable_set(:"@tool_consumer_profile", 5)
        expect(subject.tool_consumer_profile).to eq 5
      end
    end

    describe "#tool_consumer_profile=" do
      it "lets you set the tool_consuemr_profile" do
        subject.tool_consumer_profile = tool_consumer_profile
        expect(subject.instance_variable_get(:@tool_consumer_profile)).not_to be_nil
      end

      it 'converts json to a ToolConsumerProfile' do
        expect(IMS::LTI::Models::ToolConsumerProfile).to receive(:from_json).and_return(tool_consumer_profile)
        subject.tool_consumer_profile = tool_consumer_profile.to_json
      end

      it "throws an exception if the id doesn't match the tcp in the tool proxy" do
        tcp = tool_consumer_profile
        tcp.id = "bad id"
        expect { subject.tool_consumer_profile=(tcp) }.
            to raise_error(IMS::LTI::Errors::InvalidToolConsumerProfile,
                           "Tool Consumer Profile @id doesn't match the Tool Proxy")
      end


    end

    describe "#invalid_services" do
      it 'returns an empty hash if all services are valid' do
        expect(subject.invalid_services).to be_empty
      end

      it 'returns only the invalid actions for a service' do
        service = tool_consumer_profile.services_offered.find { |s| s.id == "tcp:ToolProxy.item" }
        service.action = ["GET"]
        subject.tool_consumer_profile = tool_consumer_profile
        expect(subject.invalid_services).to eq({"ToolProxy.item" => ["PUT"]})
      end

      it 'returns all a non offered service' do
        end_user_service = tool_proxy.security_contract.end_user_service
        end_user_service << IMS::LTI::Models::RestServiceProfile.from_json(
            {"@type" => "RestServiceProfile",
             "service" => "http://lms.example.com/profile/b6ffa601-ce1d-4549-9ccf-145670a964d4#Bad.service",
             "action" => ["PUT"]
            }
        )
        subj = described_class.new(tool_proxy)
        subj.tool_consumer_profile = tool_consumer_profile
        expect(subj.invalid_services).to eq({"Bad.service" => ["PUT"]})
      end

    end

    describe "#invalid_message_handlers" do
      it 'returns an empty hash if all capabilities are valid' do
        expect(subject.invalid_message_handlers).to be_empty
      end

      it 'returns the invalid capabilities' do
        mh = tool_proxy.tool_profile.resource_handlers.first.messages.first
        mh.enabled_capability = mh.enabled_capabilities << 'Bring.a.towel'
        expect(subject.invalid_message_handlers).to eq(
                                                        {
                                                            resource_handlers: [
                                                                {
                                                                    code: "asmt",
                                                                    messages: [
                                                                        {
                                                                            message_type: "basic-lti-launch-request",
                                                                            invalid_capabilities: ['Bring.a.towel']
                                                                        }
                                                                    ]
                                                                }
                                                            ]
                                                        }
                                                    )
      end

      it 'returns invalid variable parameters' do
        mh = tool_proxy.tool_profile.resource_handlers.first.messages.first
        mh.parameter = mh.parameters << IMS::LTI::Models::Parameter.new(name: 'invalid', variable: 'invalid.variable')
        expect(subject.invalid_message_handlers).to eq(
                                                        {
                                                            resource_handlers: [
                                                                {
                                                                    code: "asmt",
                                                                    messages: [
                                                                        {
                                                                            message_type: "basic-lti-launch-request",
                                                                            invalid_parameters: [{
                                                                                name: 'invalid',
                                                                                variable: 'invalid.variable'
                                                                            }]
                                                                        }
                                                                    ]
                                                                }
                                                            ]
                                                        }
                                                    )
      end

      it 'validates the message_type' do
        mh = tool_proxy.tool_profile.resource_handlers.first.messages.first
        mh.message_type = 'invalid'
        expect(subject.invalid_message_handlers).to eq(
                                                        {
                                                            resource_handlers: [
                                                                {
                                                                    code: "asmt",
                                                                    invalid_message_types: ['invalid']
                                                                }
                                                            ]
                                                        }
                                                    )
      end

      it 'validates singleton message handlers' do
        message = tool_proxy.tool_profile.resource_handlers.first.messages.first.clone
        message.message_type = 'invalid'
        tool_proxy.tool_profile.message = message
        expect(subject.invalid_message_handlers).to eq(
                                                        {
                                                            singleton_message_handlers:{
                                                                invalid_message_types: ['invalid']
                                                            }
                                                        }
                                                    )
      end

    end

    describe "#invalid_capabilities" do
      it 'returns an empty hash if all capabilities are valid' do
        expect(subject.invalid_capabilities).to be_empty
      end

      it 'returns an array of invalid capabilities' do
        tool_proxy.enabled_capability = ["SDA"]
        expect(subject.invalid_capabilities).to eq ["SDA"]
      end
    end


    describe "#invalid_security_contract" do

      it 'returns an empty hash if all services are valid' do
        expect(subject.invalid_security_contract).to be_empty
      end


      it 'rejects tool proxies that are missing a shared secret' do
        tool_proxy.security_contract.shared_secret = nil
        expect(subject.invalid_security_contract).to eq(
                                                       {
                                                         missing_secret: :shared_secret
                                                       }
                                                     )
      end


      it 'requires the "OAuth.splitSecret" capability for split secret' do
        tp_half_secret = SecureRandom.hex(64)
        tool_proxy.enabled_capability = []
        tool_proxy.security_contract.shared_secret = nil
        tool_proxy.security_contract.tp_half_shared_secret = tp_half_secret



        expect(subject.invalid_security_contract).to eq(
                                                       {
                                                         invalid_secret_type: :tp_half_shared_secret,
                                                         missing_secret: :shared_secret
                                                       }
                                                     )
      end

      it 'should pass with tp_half_secret and OAuth.splitSecret without shared secret' do
        tp_half_secret = SecureRandom.hex(64)
        tool_proxy.enabled_capability = ['OAuth.splitSecret']
        tool_proxy.security_contract.shared_secret = nil
        tool_proxy.security_contract.tp_half_shared_secret = tp_half_secret

        expect(subject.invalid_security_contract).to be_empty
      end

      it 'requires  split secret for "OAuth.splitSecret" capability' do
        tool_proxy.enabled_capability = ['OAuth.splitSecret']

        expect(subject.invalid_security_contract).to eq(
                                                       {
                                                         invalid_secret_type: :shared_secret,
                                                         missing_secret: :tp_half_shared_secret
                                                       }
                                                     )
      end

      it 'requires ONLY split secret for "OAuth.splitSecret" capability' do
        tp_half_secret = SecureRandom.hex(64)
        tool_proxy.enabled_capability = ['OAuth.splitSecret']
        tool_proxy.security_contract.tp_half_shared_secret = tp_half_secret
        expect(subject.invalid_security_contract).to eq(
                                                       {
                                                         invalid_secret_type: :shared_secret
                                                       }
                                                     )
      end

      it 'requires "OAuth.splitSecret" for tp_half_secret' do
        tp_half_secret = SecureRandom.hex(64)
        tool_proxy.enabled_capability = []
        tool_proxy.security_contract.tp_half_shared_secret = tp_half_secret
        expect(subject.invalid_security_contract).to eq(
                                                       {
                                                         invalid_secret_type: :tp_half_shared_secret
                                                       }
                                                     )
      end

    end


    describe "#errors" do

      it 'returns true if the tool proxy is valid' do

        message = tool_proxy.tool_profile.resource_handlers.first.messages.first.clone
        message.message_type = 'invalid'
        tool_proxy.tool_profile.message = message

        service = tool_consumer_profile.services_offered.find { |s| s.id == "tcp:ToolProxy.item" }
        service.action = ["GET"]
        subject.tool_consumer_profile = tool_consumer_profile

        tp_half_secret = SecureRandom.hex(64)
        tool_proxy.enabled_capability = ['OAuth.splitSecret', "DSF"]
        tool_proxy.security_contract.tp_half_shared_secret = tp_half_secret

        expect(subject.errors).to eq(
                                    {
                                      :invalid_security_contract => {
                                         :invalid_secret_type => :shared_secret
                                      },
                                      :invalid_capabilities => ["OAuth.splitSecret", "DSF"],
                                      :invalid_message_handlers => {
                                        :singleton_message_handlers => {
                                          :invalid_message_types => ["invalid"]
                                        }
                                      },
                                      :invalid_services => {
                                        "ToolProxy.item" => ["PUT"]
                                      }
                                    }
                                  )
      end
    end


    describe "#valid??" do

      it 'returns true if the tool proxy is valid' do
        expect(subject.valid?).to eq true
      end

      it 'returns an error if the TCP doesn\'t offer the services the tool proxy uses' do
        tool_consumer_profile.service_offered = []
        expect(subject.valid?).to be_falsey
      end

      it 'returns an error if the message handlers are invalid' do
        mh = tool_proxy.tool_profile.resource_handlers.first.messages.first
        mh.parameter = mh.parameters << IMS::LTI::Models::Parameter.new(name: 'invalid', variable: 'invalid.variable')
        expect(subject.valid?).to be_falsey
      end

      it 'returns an error if the capabilities are invalid' do
        tool_consumer_profile.capability_offered = []
        expect(subject.valid?).to be_falsey
      end

      it 'returns an error if the security contract is invalid' do
        tp_half_secret = SecureRandom.hex(64)
        tool_proxy.enabled_capability = ['OAuth.splitSecret']
        tool_proxy.security_contract.tp_half_shared_secret = tp_half_secret
        expect(subject.valid?).to be_falsey
      end


    end

  end
end