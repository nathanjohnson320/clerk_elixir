defmodule Clerk.User.Response do
  defmodule User do
    defstruct [
      :backup_code_enabled,
      :banned,
      :create_organization_enabled,
      :created_at,
      :delete_self_enabled,
      :email_addresses,
      :external_accounts,
      :external_id,
      :first_name,
      :has_image,
      :id,
      :image_url,
      :last_active_at,
      :last_name,
      :last_sign_in_at,
      :locked,
      :lockout_expires_in_seconds,
      :object,
      :password_enabled,
      :phone_numbers,
      :primary_email_address_id,
      :primary_phone_number_id,
      :primary_web3_wallet_id,
      :private_metadata,
      :profile_image_url,
      :public_metadata,
      :saml_accounts,
      :totp_enabled,
      :two_factor_enabled,
      :unsafe_metadata,
      :updated_at,
      :username,
      :verification_attempts_remaining,
      :web3_wallets
    ]

    defmodule Verification do
      defstruct [
        :status,
        :strategy,
        :attempts,
        :expire_at
      ]

      def new(response) do
        %__MODULE__{
          status: response["status"],
          strategy: response["strategy"],
          attempts: response["attempts"],
          expire_at: response["expire_at"]
        }
      end
    end

    defmodule Email do
      defstruct [
        :id,
        :object,
        :email_address,
        :reserved,
        :verification,
        :linked_to
      ]

      defmodule LinkedTo do
        defstruct [
          :type,
          :id
        ]

        def new(response) do
          %__MODULE__{
            type: response["type"],
            id: response["id"]
          }
        end
      end

      def new(response) do
        %__MODULE__{
          id: response["id"],
          object: response["object"],
          email_address: response["email_address"],
          reserved: response["reserved"],
          verification: Clerk.User.Response.User.Verification.new(response["verification"]),
          linked_to: Enum.map(response["linked_to"], &LinkedTo.new/1)
        }
      end
    end

    defmodule PhoneNumber do
      defstruct [
        :id,
        :object,
        :phone_number,
        :reserved_for_second_factor,
        :default_second_factor,
        :reserved,
        :verification,
        :linked_to,
        :backup_codes
      ]

      defmodule LinkedTo do
        defstruct [
          :type,
          :id
        ]

        def new(response) do
          %__MODULE__{
            type: response["type"],
            id: response["id"]
          }
        end
      end

      def new(response) do
        %__MODULE__{
          id: response["id"],
          object: response["object"],
          phone_number: response["phone_number"],
          reserved_for_second_factor: response["reserved_for_second_factor"],
          default_second_factor: response["default_second_factor"],
          reserved: response["reserved"],
          verification: Clerk.User.Response.User.Verification.new(response["verification"]),
          linked_to: Enum.map(response["linked_to"], &LinkedTo.new/1),
          backup_codes: response["backup_codes"]
        }
      end
    end

    defmodule SamlAccount do
      defstruct [
        :id,
        :object,
        :provider,
        :active,
        :email_address,
        :first_name,
        :last_name,
        :provider_user_id,
        :verification
      ]

      def new(response) do
        %__MODULE__{
          id: response["id"],
          object: response["object"],
          provider: response["provider"],
          active: response["active"],
          email_address: response["email_address"],
          first_name: response["first_name"],
          last_name: response["last_name"],
          provider_user_id: response["provider_user_id"],
          verification: Clerk.User.Response.User.Verification.new(response["verification"])
        }
      end
    end

    defmodule Web3Wallet do
      defstruct [
        :id,
        :object,
        :web3_wallet,
        :active,
        :verification
      ]

      def new(response) do
        %__MODULE__{
          id: response["id"],
          object: response["object"],
          web3_wallet: response["web3_wallet"],
          active: response["active"],
          verification: Clerk.User.Response.User.Verification.new(response["verification"])
        }
      end
    end

    defmodule ExternalAccount do
      defstruct [
        :approved_scopes,
        :avatar_url,
        :email_address,
        :first_name,
        :id,
        :identification_id,
        :image_url,
        :label,
        :last_name,
        :object,
        :provider,
        :provider_user_id,
        :public_metadata,
        :username,
        :verification
      ]

      def new(response) do
        %__MODULE__{
          approved_scopes: response["approved_scopes"],
          avatar_url: response["avatar_url"],
          email_address: response["email_address"],
          first_name: response["first_name"],
          id: response["id"],
          identification_id: response["identification_id"],
          image_url: response["image_url"],
          label: response["label"],
          last_name: response["last_name"],
          object: response["object"],
          provider: response["provider"],
          provider_user_id: response["provider_user_id"],
          public_metadata: response["public_metadata"],
          username: response["username"],
          verification: Clerk.User.Response.User.Verification.new(response["verification"])
        }
      end
    end

    def new(response) do
      %__MODULE__{
        id: response["id"],
        locked: response["locked"],
        has_image: response["has_image"],
        banned: response["banned"],
        primary_phone_number_id: response["primary_phone_number_id"],
        phone_numbers: Enum.map(response["phone_numbers"], &PhoneNumber.new/1),
        primary_email_address_id: response["primary_email_address_id"],
        email_addresses: Enum.map(response["email_addresses"], &Email.new/1),
        username: response["username"],
        first_name: response["first_name"],
        last_name: response["last_name"],
        image_url: response["image_url"],
        profile_image_url: response["profile_image_url"],
        backup_code_enabled: response["backup_code_enabled"],
        totp_enabled: response["totp_enabled"],
        two_factor_enabled: response["two_factor_enabled"],
        create_organization_enabled: response["create_organization_enabled"],
        delete_self_enabled: response["delete_self_enabled"],
        password_enabled: response["password_enabled"],
        verification_attempts_remaining: response["verification_attempts_remaining"],
        last_sign_in_at: response["last_sign_in_at"],
        last_active_at: response["last_active_at"],
        lockout_expires_in_seconds: response["lockout_expires_in_seconds"],
        external_id: response["external_id"],
        external_accounts: Enum.map(response["external_accounts"], &ExternalAccount.new/1),
        web3_wallets: Enum.map(response["web3_wallets"], &Web3Wallet.new/1),
        primary_web3_wallet_id: response["primary_web3_wallet_id"],
        saml_accounts: Enum.map(response["saml_accounts"], &SamlAccount.new/1),
        unsafe_metadata: response["unsafe_metadata"],
        public_metadata: response["public_metadata"],
        private_metadata: response["private_metadata"],
        created_at: response["created_at"],
        updated_at: response["updated_at"]
      }
    end
  end

  defmodule List do
    def new(response) do
      Enum.map(response, &User.new/1)
    end
  end
end
