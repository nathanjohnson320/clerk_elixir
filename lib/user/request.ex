defmodule Clerk.User.Request do
  defmodule List do
    defstruct [
      :email_address,
      :external_id,
      :last_active_since,
      :limit,
      :offset,
      :organization_id,
      :phone_number,
      :query,
      :user_id,
      :username,
      :web3_wallet
    ]
  end
end
