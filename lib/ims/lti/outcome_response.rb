module IMS::LTI
  class OutcomeResponse

    attr_accessor :request_type, :score, :message_identifier, :response_code,
            :post_response, :code_major, :severity, :description, :operation,
            :message_ref_identifier
    
    CODE_MAJOR_CODES = %w{success processing failure unsupported}
    SEVERITY_CODES = %w{status warning error}

    def initialize(opts={})
      opts.each_pair do |key, val|
        self.send("#{key}=", val) if self.respond_to?("#{key}=")
      end
    end

    def self.from_post_response(post_response)
      response = OutcomeResponse.new
      response.post_response = post_response
      response.response_code = post_response.code
      xml = post_response.body
      response.process_xml(xml)
      response
    end

    def success?
      @code_major == 'success'
    end

    def processing?
      @code_major == 'processing'
    end

    def failed?
      @code_major == 'failure'
    end

    def unsupported?
      @code_major == 'unsupported'
    end

    def has_warning?
      @severity == 'warning'
    end

    def has_error?
      @severity == 'error'
    end

    def process_xml(xml)
      doc = REXML::Document.new xml
      @message_identifier = doc.get_text("//imsx_statusInfo/imsx_messageIdentifier").to_s
      @code_major = doc.get_text("//imsx_statusInfo/imsx_codeMajor")
      @code_major.to_s.downcase! if @code_major
      @severity = doc.get_text("//imsx_statusInfo/imsx_severity")
      @severity.to_s.downcase! if @severity
      @description = doc.get_text("//imsx_statusInfo/imsx_description")
      @description = @description.to_s if @description
      @message_ref_identifier = doc.get_text("//imsx_statusInfo/imsx_messageRefIdentifier").to_s
      @operation = doc.get_text("//imsx_statusInfo/imsx_operationRefIdentifier").to_s
      @score = doc.get_text("//readResultResponse//resultScore/textString")
      @score = @score.to_s if @score
    end

    def generate_response_xml
      builder = Builder::XmlMarkup.new
      builder.instruct!

      builder.imsx_POXEnvelopeResponse("xmlns" => "http://www.imsglobal.org/lis/oms1p0/pox") do |env|
        env.imsx_POXHeader do |header|
          header.imsx_POXResponseHeaderInfo do |info|
            info.imsx_version "V1.0"
            info.imsx_messageIdentifier @message_identifier || IMS::LTI::generate_identifier
            info.imsx_statusInfo do |status|
              status.imsx_codeMajor @code_major
              status.imsx_severity @severity
              status.imsx_description @description
              status.imsx_messageRefIdentifier @message_ref_identifier
              status.imsx_operationRefIdentifier @operation
            end
          end
        end #/header
        env.imsx_POXBody do |body|
          unless unsupported?
            body.tag!(@operation + 'Response') do |request|
              if @operation == OutcomeRequest::READ_REQUEST
                request.result do |res|
                  res.resultScore do |res_score|
                    res_score.language "en" # 'en' represents the format of the number
                    res_score.textString @score.to_s
                  end
                end #/result
              end
            end #/operationResponse
          end
        end #/body
      end
    end

  end
end
