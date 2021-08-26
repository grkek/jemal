module JemalWeb
  module Controllers
    class SignInController < Grip::Controllers::Http
      property encoder : Authorization::BidirectionalEncoder = Authorization::BidirectionalEncoder.new(AUTHORIZATION_CONFIGURATION)

      alias User = Jemal::Models::Accounts::User

      def post(context : Context) : Context
        email = context.fetch_json_params.["email"].to_s
        password = context.fetch_json_params.["password"].to_s

        begin
          user = User.find_by!(email: email)
          token = encoder.encode({"sub" => user.id})

          if Crypto::Bcrypt::Password.new(user.password).verify(password)
            context
            .json({"token" => token})
          else
            context
            .put_status(401)
          end
        rescue
          context
          .put_status(400)
        ensure
          context
          .halt
        end
      end
    end
  end
end
