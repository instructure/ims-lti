module IMS::LTI
  module Extensions

    # An LTI extension that adds support for sending data back to the consumer
    # in addition to the score.
    #
    #     # Initialize TP object with OAuth creds and post parameters
    #     provider = IMS::LTI::ToolProvider.new(consumer_key, consumer_secret, params)
    #     # add extension
    #     provider.extend IMS::LTI::Extensions::OutcomeData::ToolProvider
    #
    # If the tool was launch as an outcome service and it supports the data extension
    # you can POST a score to the TC.
    # The POST calls all return an OutcomeResponse object which can be used to
    # handle the response appropriately.
    #
    #     # post the score to the TC, score should be a float >= 0.0 and <= 1.0
    #     # this returns an OutcomeResponse object
    #     if provider.accepts_outcome_text?
    #       response = provider.post_replace_result_with_data!(score, "text" => "submission text")
    #     else
    #       response = provider.post_replace_result!(score)
    #     end
    #     if response.success?
    #       # grade write worked
    #     elsif response.processing?
    #     elsif response.unsupported?
    #     else
    #       # failed
    #     end
    module OutcomeData

      #IMS::LTI::Extensions::OutcomeData::ToolProvider
      module Base
        def outcome_request_extensions
          super + [IMS::LTI::Extensions::OutcomeData::OutcomeRequest]
        end
      end

      module ToolProvider
        include IMS::LTI::Extensions::ExtensionBase
        include Base

        # a list of the supported outcome data types
        def accepted_outcome_types
          return @outcome_types if @outcome_types
          @outcome_types = []
          if val = @ext_params["outcome_data_values_accepted"]
            @outcome_types = val.split(',')
          end

          @outcome_types
        end

        # check if the outcome data extension is supported
        def accepts_outcome_data?
          !!@ext_params["outcome_data_values_accepted"]
        end

        # check if the consumer accepts text as outcome data
        def accepts_outcome_text?
          accepted_outcome_types.member?("text")
        end

        # check if the consumer accepts a url as outcome data
        def accepts_outcome_url?
          accepted_outcome_types.member?("url")
        end

        # POSTs the given score to the Tool Consumer with a replaceResult and
        # adds the specified data. The data hash can have the keys "text", "cdata_text", or "url"
        #
        # If  both cdata_text and text are sent, cdata_text will be used
        #
        # Creates a new OutcomeRequest object and stores it in @outcome_requests
        #
        # @return [OutcomeResponse] the response from the Tool Consumer
        def post_replace_result_with_data!(score, data={})
          req = new_request
          if data["cdata_text"] 
            req.outcome_cdata_text = data["cdata_text"] 
          elsif data["text"]
            req.outcome_text = data["text"]
          end
          req.outcome_url = data["url"] if data["url"]
          req.post_replace_result!(score)
        end

      end

      module ToolConsumer
        include IMS::LTI::Extensions::ExtensionBase
        include Base
        
        OUTCOME_DATA_TYPES = %w{text url}

        # a list of the outcome data types accepted, currently only 'url' and
        # 'text' are valid
        #
        #    tc.outcome_data_values_accepted(['url', 'text'])
        #    tc.outcome_data_valued_accepted("url,text")
        def outcome_data_values_accepted=(val)
          if val.is_a? Array
            val = val.join(',')
          end
          
          set_ext_param('outcome_data_values_accepted', val)
        end

        # a comma-separated string of the supported outcome data types
        def outcome_data_values_accepted
          get_ext_param('outcome_data_values_accepted')
        end
        
        # convenience method for setting support for all current outcome data types
        def support_outcome_data!
          self.outcome_data_values_accepted = OUTCOME_DATA_TYPES
        end
      end

      module OutcomeRequest
        include IMS::LTI::Extensions::ExtensionBase
        include Base

        attr_accessor :outcome_text, :outcome_url, :outcome_cdata_text

        def result_values(node)
          super
          if @outcome_text || @outcome_url || @outcome_cdata_text
            node.resultData do |res_data|
              if @outcome_cdata_text
                res_data.text {
                  res_data.cdata! @outcome_cdata_text
                }
              elsif @outcome_text
                res_data.text @outcome_text
              end
              res_data.url @outcome_url if @outcome_url
            end
          end
        end

        def has_result_data?
          !!@outcome_text || !!@outcome_url || super
        end
        
        def extention_process_xml(doc)
          super
          @outcome_text = doc.get_text("//resultRecord/result/resultData/text")
          @outcome_url = doc.get_text("//resultRecord/result/resultData/url")
        end
      end

    end
  end
end