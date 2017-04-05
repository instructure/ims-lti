module IMS::LTI::OAuthFaradayMiddleware
  def oauth_options(env)
    @options.merge! body_hash: Digest::SHA1.base64digest(env[:body]) unless include_body_params?(env)
    if extra = env[:request][:oauth] and extra.is_a? Hash and !extra.empty?
      @options.merge extra
    else
      @options
    end
  end
end