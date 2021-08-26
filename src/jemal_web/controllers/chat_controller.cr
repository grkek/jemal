module JemalWeb
  module Controllers
    class ChatController < Grip::Controllers::WebSocket

      alias User = Jemal::Models::Accounts::User

      property bidirectional_encoder = Authorization::BidirectionalEncoder.new(AUTHORIZATION_CONFIGURATION)
      property sockets : Array(Socket) = [] of Socket

      def on_open(context : Context, socket : Socket) : Void
        @sockets.push(socket)
      end

      def on_message(context : Context, socket : Socket, message : String) : Void
        token = context.fetch_query_params.["token"]
        payload = @bidirectional_encoder.decode_with_payload!(token)
        id = payload.["sub"]

        current_user = User.find!(id)

        @sockets.each do |client|
          client.send({"id" => current_user.id, "time" => Time.utc.to_unix, "displayName" => current_user.first_name, "message" => HTML.escape(message)}.to_json)
        end
      end

      def on_ping(context : Context, socket : Socket, message : String) : Void
        # Executed when a client pings the server.
      end

      def on_pong(context : Context, socket : Socket, message : String) : Void
        # Executed when a server receives a pong.
      end

      def on_binary(context : Context, socket : Socket, binary : Bytes) : Void
        # Executed when a client sends a binary message.
      end

      def on_close(context : Context, socket : Socket, error_code : HTTP::WebSocket::CloseCode | Int?, message : String) : Void
        @sockets.delete(socket)
      end
    end
  end
end
