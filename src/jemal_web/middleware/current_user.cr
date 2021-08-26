module JemalWeb
  module Middleware
    class CurrentUser
      include HTTP::Handler

      alias User = Jemal::Models::Accounts::User

      def call(context : HTTP::Server::Context) : HTTP::Server::Context
        id = context
          .authorization
          .["sub"]

        context.current_user = User.find!(id)
        context
      end
    end
  end
end
