module JemalWeb
  module Controllers
    class UserController < Grip::Controllers::Http
      alias User = Jemal::Models::Accounts::User

      def me(context : Context) : Context
        context
        .serialize(User.find!(context.current_user.id))
        .halt
      end
    end
  end
end
