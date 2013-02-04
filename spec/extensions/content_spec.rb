require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')

describe IMS::LTI::Extensions do
  before do
    create_params
    @params['ext_content_intended_use'] = "homework"
    @params['ext_content_return_types'] = "file,url,lti_launch_url,image_url,iframe,oembed"
    @params['ext_content_return_url'] = "http://example.com/content_return"
    @params['ext_content_file_extensions'] = ''
    @tp = IMS::LTI::ToolProvider.new("hi", 'oi', @params)
    @tp.extend IMS::LTI::Extensions::Content::ToolProvider
  end

  it "should correctly interpret extension parameters" do
    @tp.accepts_content?.should == true
    @tp.accepts_content_type?(:file).should == true
    @tp.accepts_content_type?(:url).should == true
    @tp.accepts_content_type?(:other).should == false

    @tp.content_intended_use.should == :homework
    @tp.is_content_for?(:homework).should == true
    @tp.is_content_for?(:embed).should == false

    @tp.content_return_url.should == @params['ext_content_return_url']

    #TODO: Add tests for file extensions
  end

  it "should recognize accepted return types" do
    @tp.accepts_file?.should == true
    @tp.accepts_url?.should == true
    @tp.accepts_lti_launch_url?.should == true
    @tp.accepts_image_url?.should == true
    @tp.accepts_iframe?.should == true
    @tp.accepts_oembed?.should == true
  end

  describe "generate return urls" do
    let(:url) {"http://externalhost.com/resource"}
    let(:text) {"my-text"}
    let(:content_type) {"text/plain"}
    let(:title) {"A title"}
    let(:width) {250}
    let(:height) {200}
    let(:alt) {"Alternate text"}
    let(:endpoint) {"http://endpoint.com"}

    it "should generate a file return url" do
      return_url = @tp.file_content_return_url(url, text, content_type)

      return_url.include?("return_type=file").should == true
      return_url.include?("url=#{CGI::escape(url)}").should == true
      return_url.include?("text=#{CGI::escape(text)}").should == true
      return_url.include?("content_type=#{CGI::escape(content_type)}").should == true
    end

    it "should generate a url return url" do
      return_url = @tp.url_content_return_url(url, title, text, '_blank')

      return_url.include?("return_type=url").should == true
      return_url.include?("url=#{CGI::escape(url)}").should == true
      return_url.include?("title=#{CGI::escape(title)}").should == true
      return_url.include?("text=#{CGI::escape(text)}").should == true
      return_url.include?("target=_blank").should == true
    end

    it "should generate a lti launch return url" do
      return_url = @tp.lti_launch_content_return_url(url, text, title)

      return_url.include?("return_type=lti_launch_url").should == true
      return_url.include?("url=#{CGI::escape(url)}").should == true
      return_url.include?("text=#{CGI::escape(text)}").should == true
      return_url.include?("title=#{CGI::escape(title)}").should == true
    end

    it "should generate a image return url" do
      return_url = @tp.image_content_return_url(url, width, height, alt)

      return_url.include?("return_type=image_url").should == true
      return_url.include?("url=#{CGI::escape(url)}").should == true
      return_url.include?("width=#{width}").should == true
      return_url.include?("height=#{height}").should == true
      return_url.include?("alt=#{CGI::escape(alt)}").should == true
    end

    it "should generate an iframe return url" do
      return_url = @tp.iframe_content_return_url(url, width, height, title)

      return_url.include?("return_type=iframe").should == true
      return_url.include?("url=#{CGI::escape(url)}").should == true
      return_url.include?("width=#{width}").should == true
      return_url.include?("height=#{height}").should == true
      return_url.include?("title=#{CGI::escape(title)}").should == true
    end

    it "should generate an oembed return url" do
      return_url = @tp.oembed_content_return_url(url, endpoint)

      return_url.include?("return_type=oembed").should == true
      return_url.include?("url=#{CGI::escape(url)}").should == true
      return_url.include?("endpoint=#{CGI::escape(endpoint)}").should == true
    end
  end

  describe "tool consumer" do
    let(:tc) do
      tc = IMS::LTI::ToolConsumer.new("hey", "ho")
      tc.extend IMS::LTI::Extensions::Content::ToolConsumer
    end

    it "should accept content return types" do
      tc.content_return_types= %w{lti_launch_url file}
      tc.content_return_types.split(',').size.should == 2
      %w{lti_launch_url file}.each {|type| tc.content_return_types.include?(type).should == true}

      tc.content_return_types= 'oembed,url,image_url'
      tc.content_return_types.split(',').size.should == 3
      %w{oembed url image_url}.each {|type| tc.content_return_types.include?(type).should == true}
    end

    it "should support homework content" do
      tc.support_homework_content!
      tc.content_intended_use.should == 'homework'
      %w{file url }.each {|type| tc.content_return_types.include?(type).should == true}
    end

    it "should support embed content" do
      tc.support_embed_content!
      tc.content_intended_use.should == 'embed'
      %w{oembed lti_launch_url url image_url iframe}.each {|type| tc.content_return_types.include?(type).should == true}
    end

    it "should support navigation content" do
      tc.support_navigation_content!
      tc.content_intended_use.should == 'navigation'
      %w{lti_launch_url}.each {|type| tc.content_return_types.include?(type).should == true}
    end
  end
end