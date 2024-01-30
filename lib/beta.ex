defmodule Clerk.Beta do
  @moduledoc """
  Modify instance settings that are currently in beta.
  """

  alias Clerk.HTTP

  @doc """
  Updates the settings of an instance

  ## REQUEST BODY SCHEMA: application/json
  ### restricted_to_allowlist
  boolean or null
  Default: false
  Whether sign up is restricted to email addresses, phone numbers and usernames that are on the allowlist.

  ### from_email_address
  string or null
  The local part of the email address from which authentication-related emails (e.g. OTP code, magic links) will be sent. Only alphanumeric values are allowed. Note that this value should contain only the local part of the address (e.g. foo for foo@example.com).

  ### progressive_sign_up
  boolean or null
  Enable the Progressive Sign Up algorithm. Refer to the docs for more info.

  ### session_token_template
  string or null
  The name of the JWT Template used to augment your session tokens. To disable this, pass an empty string.

  ### enhanced_email_deliverability
  boolean or null
  The "enhanced_email_deliverability" feature will send emails from "verifications@clerk.dev" instead of your domain. This can be helpful if you do not have a high domain reputation.

  ### test_mode
  boolean or null
  Toggles test mode for this instance, allowing the use of test email addresses and phone numbers. Defaults to true for development instances.
  """
  def update_instance_settings(params, opts \\ []) do
    HTTP.patch("/v1/beta_features/instance_settings", params, %{}, opts)
  end

  @doc """
  Change the domain of a production instance.

  Changing the domain requires updating the DNS records accordingly, deploying new SSL certificates, updating your Social Connection's redirect URLs and setting the new keys in your code.

  WARNING: Changing your domain will invalidate all current user sessions (i.e. users will be logged out). Also, while your application is being deployed, a small downtime is expected to occur.

  ## REQUEST BODY SCHEMA: application/json
  ### home_url
  string
  The new home URL of the production instance e.g. https://www.example.com
  """
  def update_production_instance_domain(params, opts \\ []) do
    HTTP.post("/v1/instance/change_domain", params, %{}, opts)
  end
end
