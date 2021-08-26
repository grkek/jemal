module JemalWeb
  module Controllers
    class SignUpController < Grip::Controllers::Http
      property encoder : Authorization::BidirectionalEncoder = Authorization::BidirectionalEncoder.new(AUTHORIZATION_CONFIGURATION)

      alias User = Jemal::Models::Accounts::User

      def post(context : Context) : Context
        first_name = context.fetch_json_params.["firstName"].to_s
        last_name = context.fetch_json_params.["lastName"].to_s
        email = context.fetch_json_params.["email"].to_s
        password = context.fetch_json_params.["password"].to_s

        begin
          user = User.create!(
            first_name: first_name,
            last_name: last_name,
            email: email,
            password: password
          )

          token = encoder.encode({"sub" => user.id})

          context
          .put_status(201)
          .json({"token" => token})
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
