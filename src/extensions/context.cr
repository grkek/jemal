require "../jemal/models/accounts/user"

class HTTP::Server::Context
  alias User = Jemal::Models::Accounts::User

  property current_user : User = User.new

  def serialize(model, content_type = "application/json; charset=UTF-8")
    @response.headers["Content-Type"] = content_type
    @response.print(ASR.serializer.serialize(model, :json))
    self
  end
end
