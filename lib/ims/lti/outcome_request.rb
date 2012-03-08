module IMS::LTI
  class OutcomeRequest

    REPLACE_REQUEST = 'replaceResult'
    DELETE_REQUEST = 'deleteResult'
    READ_REQUEST = 'readResult'

    attr_accessor :operation, :score, :outcome_response, :message_identifier,
            :lis_outcome_service_url, :lis_result_sourcedid, :consumer_key, :consumer_secret

    def initialize(opts={})
      opts.each_pair do |key, val|
        self.send("#{key}=", val) if self.respond_to?("#{key}=")
      end
    end

    def self.from_post_request(post_request)
      request = OutcomeRequest.new
      request.post_request = post_request
      xml = post_request.body
      process_xml(xml)
      request
    end

    # Posts the given score to the Tool Consumer with a replaceResult
    def post_replace_result!(score)
      @operation = REPLACE_REQUEST
      @score = score
      post_outcome_request
    end

    def post_delete_result!
      @operation = DELETE_REQUEST
      post_outcome_request
    end

    def post_read_result!
      @operation = READ_REQUEST
      post_outcome_request
    end

    def outcome_post_successful?
      @outcome_response && @outcome_response.success?
    end

    def post_outcome_request
      raise IMS::LTI::InvalidLTIConfigError, "" unless has_required_attributes?

      consumer = OAuth::Consumer.new(@consumer_key, @consumer_secret)
      token = OAuth::AccessToken.new(consumer)
      res = token.post(
              @lis_outcome_service_url,
              generate_request_xml,
              'Content-Type' => 'application/xml'
      )
      @outcome_response = OutcomeResponse.from_post_response(res)
    end

    def process_xml(xml)
      doc = REXML::Document.new xml
      @message_identifier = doc.get_text("//imsx_POXRequestHeaderInfo/imsx_messageIdentifier")
      @lis_result_sourcedid = doc.get_text("//resultRecord/sourcedGUID/sourcedId")

      if REXML::XPath.first(doc, "//deleteResultRequest")
        @operation = DELETE_REQUEST
      elsif REXML::XPath.first(doc, "//readResultRequest")
        @operation = READ_REQUEST
      elsif REXML::XPath.first(doc, "//replaceResultRequest")
        @operation = REPLACE_REQUEST
        @score = doc.get_text("//resultRecord/result/resultScore/textString")
      end
    end

    private

    def has_required_attributes?
      @consumer_key && @consumer_secret && @lis_outcome_service_url && @lis_result_sourcedid && @operation
    end

    def generate_request_xml
      builder = Builder::XmlMarkup.new #(:indent=>2)
      builder.instruct!

      builder.imsx_POXEnvelopeRequest("xmlns" => "http://www.imsglobal.org/lis/oms1p0/pox") do |env|
        env.imsx_POXHeader do |header|
          header.imsx_POXRequestHeaderInfo do |info|
            info.imsx_version "V1.0"
            info.imsx_messageIdentifier @message_identifier || IMS::LTI::generate_identifier
          end
        end
        env.imsx_POXBody do |body|
          body.tag!(@operation + 'Request') do |request|
            request.resultRecord do |record|
              record.sourcedGUID do |guid|
                guid.sourcedId @lis_result_sourcedid
              end
              if @score
                record.result do |res|
                  res.resultScore do |res_score|
                    res_score.language "en" # 'en' represents the format of the number
                    res_score.textString @score.to_s
                  end
                end
              end
            end
          end
        end
      end
    end

  end
end
