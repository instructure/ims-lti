require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')

describe IMS::LTI::Extensions do
  before do
    create_params
    @params['ext_content_intended_use'] = "homework"
    @params['ext_content_return_types'] = "file,url,lti_launch_url,image_url,iframe,oembed"
    @params['ext_content_return_url'] = "http://example.com/content_return?extra_param=foo"
    @params['ext_content_file_extensions'] = 'txt,jpg'
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
    @tp.accepts_file?('my_file.txt').should == true
    @tp.accepts_file?('my_file.jpg').should == true
    @tp.accepts_file?('my_file.csv').should == false
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

    def url_params(url)
      parsed = URI.parse(url)
      return CGI.parse(parsed.query) if parsed&.query
    end

    it "should generate a file return url" do
      return_url = @tp.file_content_return_url(url, text, content_type)

      return_params = url_params(return_url)

      return_params["return_type"][0].should == "file"
      return_params["url"][0].should == url
      return_params["text"][0].should == text
      return_params["content_type"][0].should == content_type
    end

    it "should generate a url return url" do
      return_url = @tp.url_content_return_url(url, title, text, '_blank')

      return_params = url_params(return_url)

      return_params["return_type"][0].should == "url"
      return_params["url"][0].should == url
      return_params["title"][0].should == title
      return_params["text"][0].should == text
      return_params["target"][0].should == "_blank"
    end

    it "should generate a lti launch return url" do
      return_url = @tp.lti_launch_content_return_url(url, text, title)

      return_params = url_params(return_url)

      return_params["return_type"][0].should == "lti_launch_url"
      return_params["url"][0].should == url
      return_params["text"][0].should == text
      return_params["title"][0].should == title
    end

    it "should generate a image return url" do
      return_url = @tp.image_content_return_url(url, width, height, alt)

      return_params = url_params(return_url)

      return_params["return_type"][0].should == "image_url"
      return_params["url"][0].should == url
      return_params["width"][0].should == "#{width}"
      return_params["height"][0].should == "#{height}"
      return_params["alt"][0].should == alt
    end

    it "should generate an iframe return url" do
      return_url = @tp.iframe_content_return_url(url, width, height, title)

      return_params = url_params(return_url)

      return_params["return_type"][0].should == "iframe"
      return_params["url"][0].should == url
      return_params["width"][0].should == "#{width}"
      return_params["height"][0].should == "#{height}"
      return_params["title"][0].should == title
    end

    it "should generate an oembed return url" do
      return_url = @tp.oembed_content_return_url(url, endpoint)

      return_params = url_params(return_url)

      return_params["return_type"][0].should == "oembed"
      return_params["url"][0].should == url
      return_params["endpoint"][0].should == endpoint
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