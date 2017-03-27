require 'spec_helper'

module IMS::LTI::Models
  describe SecurityProfile do

    it 'has a security_profile_name attribute' do
      subject.security_profile_name = 'test'
      expect(subject.security_profile_name).to eq 'test'
    end

    it 'has a digest_algorithm attribute' do
      subject.digest_algorithm = 'test'
      expect(subject.digest_algorithm).to eq 'test'
    end

    it 'pluralizes digest_algoritim' do
      subject.digest_algorithm = 'test'
      expect(subject.digest_algorithms).to eq ['test']
    end

  end
end