require "granite/adapter/pg"
require "grip"
require "authorization"
require "crypto/bcrypt/password"
require "athena-serializer"

require "./extensions/**"
require "./jemal"
require "./jemal_web"

require "./jemal/**"
require "./jemal_web/**"

AUTHORIZATION_CONFIGURATION = Authorization::Configuration.new(algorithm: JWT::Algorithm::HS512, issuer: "Authorization Company", audience: "Authorization", secret_key: "MY_SECRET_KEY")

class Application < Grip::Application
  alias Controllers = JemalWeb::Controllers
  alias Middleware = JemalWeb::Middleware

  def routes
    pipeline :api, [
      Authorization::Middleware.new(AUTHORIZATION_CONFIGURATION),
      Middleware::CurrentUser.new,
    ]

    scope "/api" do
      scope "/accounts" do
        post "/signin", Controllers::SignInController
        post "/signup", Controllers::SignUpController
      end

      scope "/accounts" do
        pipe_through :api

        get "/me", Controllers::UserController, as: :me
      end

      scope "/accounts" do
        ws "/chat", Controllers::ChatController
      end
    end
  end
end

app = Application.new
app.run
