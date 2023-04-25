
class JsonWebToken

  KEY = '242644e8afe2d587e8ddb6e1f82001e3968ec7e7054fb1dc3795ee1652aac6ce13416d632cd94f7b3c951a7ed2033696913fbac658b533172b089ce6af4418a2'

  def self.encode(payload)
    JWT.encode(payload, KEY)
  end

  def self.decode(token)
    return HashWithIndifferentAccess.new(JWT.decode(token, KEY)[0])
  rescue
    nil
  end
end
