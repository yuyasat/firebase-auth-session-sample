class CheckJwt
  private attr_reader :token

  def initialize(token)
    @token = token
  end

  def call
    return nil unless token

    decoded_token = JWT.decode(token, nil, false)

    # ruby-jwtを使うと、JWTのHeader部が配列の２番目に入ってくる
    kid = decoded_token.dig(1, "kid")
    algorithm = decoded_token.dig(1, "alg")

    # https://firebase.google.com/docs/auth/admin/verify-id-tokens
    response = Typhoeus.get(
      "https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com"
    )

    jwks_string = JSON.parse(response.body)[kid].gsub(
      /-----BEGIN CERTIFICATE-----|-----END CERTIFICATE-----/, ''
    )

    JWT.decode(token, OpenSSL::X509::Certificate.new(Base64.decode64(jwks_string)).public_key, true, { algorithm: algorithm })
  rescue JWT::ExpiredSignature, JWT::VerificationError
    nil
  end
end
