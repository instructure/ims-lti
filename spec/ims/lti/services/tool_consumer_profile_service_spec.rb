require 'spec_helper'

module IMS::LTI::Services
  describe ToolConsumerProfileService do

    let(:tcp){IMS::LTI::Models::ToolConsumerProfile.new(capability_offered: %w(User.name User.email))}

    let(:tcp_service) { ToolConsumerProfileService.new(tcp) }

    describe "supports_capabilities?" do

      it "returns true if it supports the provided capability" do
        expect(tcp_service.supports_capabilities?('User.name')).to eq true
      end

      it 'returns false if the provided capabilities are not supported' do
        expect(tcp_service.supports_capabilities?('User.invalide')).to eq false
      end

      it 'accepts multiple capabilities' do
        expect(tcp_service.supports_capabilities?('User.name', 'User.email')).to eq true
      end

    end


  end
end