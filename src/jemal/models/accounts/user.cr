require "uuid/json"

module Jemal
  module Models
    module Accounts
      @[ASRA::ExclusionPolicy(:all)]
      class User < Granite::Base
        include ASR::Serializable

        Granite::Connections << Granite::Adapter::Pg.new(name: "postgres", url: "postgresql://postgres:postgres@localhost:5432/jemal_dev")
        connection postgres
        table users

        @[ASRA::Expose]
        column id : UUID, converter: Granite::Converters::Uuid(String) , primary: true, auto: false

        @[ASRA::Expose]
        column email : String

        @[ASRA::IgnoreOnSerialize]
        column password : String

        @[ASRA::Expose]
        column first_name : String

        @[ASRA::Expose]
        column last_name : String

        validate_not_blank :email
        validate_not_blank :password
        validate_not_blank :first_name
        validate_not_blank :last_name
        validate_uniqueness :email

        before_create :assign_id
        before_save :hash_password

        def hash_password : Nil
          if password = @password
            @password = Crypto::Bcrypt::Password.create(password).to_s
          end
        end

        def assign_id
          @id = UUID.random
        end
      end
    end
  end
end
