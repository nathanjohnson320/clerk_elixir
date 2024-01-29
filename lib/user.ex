defmodule Clerk.User do
  alias Clerk.HTTP

  @doc """
  Retrieve the details of a user
  """
  def get(user_id, opts \\ []) do
    HTTP.get("/v1/users/#{user_id}", %{}, opts)
  end

  @doc """
  Returns a list of all users. The users are returned sorted by creation date, with the newest users appearing first.

  ## QUERY PARAMETERS

  ### email_address
  Array of strings
  Returns users with the specified email addresses. Accepts up to 100 email addresses. Any email addresses not found are ignored.

  ### phone_number
  Array of strings
  Returns users with the specified phone numbers. Accepts up to 100 phone numbers. Any phone numbers not found are ignored.

  ### external_id
  Array of strings
  Returns users with the specified external ids. For each external id, the + and - can be prepended to the id, which denote whether the respective external id should be included or excluded from the result set. Accepts up to 100 external ids. Any external ids not found are ignored.

  ### username
  Array of strings
  Returns users with the specified usernames. Accepts up to 100 usernames. Any usernames not found are ignored.

  ### web3_wallet
  Array of strings
  Returns users with the specified web3 wallet addresses. Accepts up to 100 web3 wallet addresses. Any web3 wallet addressed not found are ignored.

  ### user_id
  Array of strings
  Returns users with the user ids specified. For each user id, the + and - can be prepended to the id, which denote whether the respective user id should be included or excluded from the result set. Accepts up to 100 user ids. Any user ids not found are ignored.

  ### organization_id
  Array of strings
  Returns users that have memberships to the given organizations. For each organization id, the + and - can be prepended to the id, which denote whether the respective organization should be included or excluded from the result set. Accepts up to 100 organization ids.

  ### query
  string
  Returns users that match the given query. For possible matches, we check the email addresses, phone numbers, usernames, web3 wallets, user ids, first and last names. The query value doesn't need to match the exact value you are looking for, it is capable of partial matches as well.

  ### last_active_at_since
  integer
  Returns users that had session activity since the given date, with day precision. Providing a value with higher precision than day will result in an error. Example: use 1700690400000 to retrieve users that had session activity from 2023-11-23 until the current day.

  Example: last_active_at_since=1700690400000

  ### limit
  number [ 1 .. 500 ]
  Default: 10
  Applies a limit to the number of results returned. Can be used for paginating the results together with offset. Must be an integer greater than zero and less than 500. By default, if not supplied, a limit of 10 is used.

  ### offset
  number >= 0
  Default: 0
  Skip the first offset results when paginating. Needs to be an integer greater or equal to zero. To be used in conjunction with limit.

  ### order_by
  string
  Default: "-created_at"
  Allows to return users in a particular order. At the moment, you can order the returned users by their created_at,updated_at,email_address,web3wallet,first_name,last_name,phone_number,username,last_active_at,last_sign_in_at. In order to specify the direction, you can use the +/- symbols prepended in the property to order by. For example, if you want users to be returned in descending order according to their created_at property, you can use -created_at. If you don't use + or -, then + is implied. We only support one order_by parameter, and if multiple order_by parameters are provided, we will only keep the first one. For example, if you pass order_by=username&order_by=created_at, we will consider only the first order_by parameter, which is username. The created_at parameter will be ignored in this case.
  """
  def list(params \\ %{}, opts \\ []) do
    HTTP.get("/v1/users", params, opts)
  end

  @doc """
  Creates a new user. Your user management settings determine how you should setup your user model.

  ## REQUEST BODY SCHEMA: application/json

  ### external_id
  string or null
  The ID of the user as used in your external systems or your previous authentication solution. Must be unique across your instance.

  ### first_name
  string or null
  The first name to assign to the user

  ### last_name
  string or null
  The last name to assign to the user

  ### email_address
  Array of strings
  Email addresses to add to the user. Must be unique across your instance. The first email address will be set as the user's primary email address.

  ### phone_number
  Array of strings
  Phone numbers to add to the user. Must be unique across your instance. The first phone number will be set as the user's primary phone number.

  ### web3_wallet
  Array of strings
  Web3 wallets to add to the user. Must be unique across your instance. The first wallet will be set as the user's primary wallet.

  ### username
  string or null
  The username to give to the user. It must be unique across your instance.

  ### password
  string or null
  The plaintext password to give the user. Must be at least 8 characters long, and can not be in any list of hacked passwords.

  ### password_digest
  string
  In case you already have the password digests and not the passwords, you can use them for the newly created user via this property. The digests should be generated with one of the supported algorithms. The hashing algorithm can be specified using the password_hasher property.

  ### password_hasher
  string
  The hashing algorithm that was used to generate the password digest. The algorithms we support at the moment are bcrypt, bcrypt_sha256_django, md5, pbkdf2_sha256, pbkdf2_sha256_django, phpass, scrypt_firebase, sha256 and the argon2 variants argon2i and argon2id.

  ### skip_password_checks
  boolean
  When set to true all password checks are skipped. It is recommended to use this method only when migrating plaintext passwords to Clerk. Upon migration the user base should be prompted to pick stronger password.

  ### skip_password_requirement
  boolean
  When set to true, password is not required anymore when creating the user and can be omitted. This is useful when you are trying to create a user that doesn't have a password, in an instance that is using passwords. Please note that you cannot use this flag if password is the only way for a user to sign into your instance.

  ### totp_secret
  string
  In case TOTP is configured on the instance, you can provide the secret to enable it on the newly created user without the need to reset it. Please note that currently the supported options are:

  Period: 30 seconds
  Code length: 6 digits
  Algorithm: SHA1

  ### backup_codes
  Array of strings
  If Backup Codes are configured on the instance, you can provide them to enable it on the newly created user without the need to reset them. You must provide the backup codes in plain format or the corresponding bcrypt digest.

  ### public_metadata
  object
  Metadata saved on the user, that is visible to both your Frontend and Backend APIs

  ### private_metadata
  object
  Metadata saved on the user, that is only visible to your Backend API

  ### unsafe_metadata
  object
  Metadata saved on the user, that can be updated from both the Frontend and Backend APIs. Note: Since this data can be modified from the frontend, it is not guaranteed to be safe.

  ### created_at
  string
  A custom date/time denoting when the user signed up to the application, specified in RFC3339 format (e.g. 2012-10-20T07:15:20.902Z).
  """
  def create(params, opts \\ []) do
    HTTP.post("/v1/users", params, %{}, opts)
  end

  @doc """
  Returns a total count of all users that match the given filtering criteria.

  ## QUERY PARAMETERS
  ### email_address
  Array of strings
  Counts users with the specified email addresses. Accepts up to 100 email addresses. Any email addresses not found are ignored.

  ### phone_number
  Array of strings
  Counts users with the specified phone numbers. Accepts up to 100 phone numbers. Any phone numbers not found are ignored.

  ### external_id
  Array of strings
  Counts users with the specified external ids. Accepts up to 100 external ids. Any external ids not found are ignored.

  ### username
  Array of strings
  Counts users with the specified usernames. Accepts up to 100 usernames. Any usernames not found are ignored.

  ### web3_wallet
  Array of strings
  Counts users with the specified web3 wallet addresses. Accepts up to 100 web3 wallet addresses. Any web3 wallet addressed not found are ignored.

  ### user_id
  Array of strings
  Counts users with the user ids specified. Accepts up to 100 user ids. Any user ids not found are ignored.

  ### query
  string
  Counts users that match the given query. For possible matches, we check the email addresses, phone numbers, usernames, web3 wallets, user ids, first and last names. The query value doesn't need to match the exact value you are looking for, it is capable of partial matches as well.
  """
  def count(params \\ %{}, opts \\ []) do
    HTTP.get("/v1/users/count", params, opts)
  end

  @doc """
  Update a user's attributes.

  ## REQUEST BODY SCHEMA: application/json

  ### external_id
  string or null
  The ID of the user as used in your external systems or your previous authentication solution. Must be unique across your instance.

  ### first_name
  string or null
  The first name to assign to the user

  ### last_name
  string or null
  The last name to assign to the user

  ### primary_email_address_id
  string
  The ID of the email address to set as primary. It must be verified, and present on the current user.

  ### notify_primary_email_address_changed
  boolean
  Default: false
  If set to true, the user will be notified that their primary email address has changed. By default, no notification is sent.

  ### primary_phone_number_id
  string
  The ID of the phone number to set as primary. It must be verified, and present on the current user.

  ### primary_web3_wallet_id
  string
  The ID of the web3 wallets to set as primary. It must be verified, and present on the current user.

  ### username
  string or null
  The username to give to the user. It must be unique across your instance.

  ### profile_image_id
  string or null
  The ID of the image to set as the user's profile image

  ### password
  string or null
  The plaintext password to give the user. Must be at least 8 characters long, and can not be in any list of hacked passwords.

  ### password_digest
  string
  In case you already have the password digests and not the passwords, you can use them for the newly created user via this property. The digests should be generated with one of the supported algorithms. The hashing algorithm can be specified using the password_hasher property.

  ### password_hasher
  string
  The hashing algorithm that was used to generate the password digest. The algorithms we support at the moment are bcrypt, bcrypt_sha256_django, md5, pbkdf2_sha256, pbkdf2_sha256_django, phpass, scrypt_firebase, sha256 and the argon2 variants argon2i and argon2id.

  ### skip_password_checks
  boolean or null
  Set it to true if you're updating the user's password and want to skip any password policy settings check. This parameter can only be used when providing a password.

  ### sign_out_of_other_sessions
  boolean or null
  Set to true to sign out the user from all their active sessions once their password is updated. This parameter can only be used when providing a password.

  ### totp_secret
  string
  In case TOTP is configured on the instance, you can provide the secret to enable it on the specific user without the need to reset it. Please note that currently the supported options are:

  Period: 30 seconds
  Code length: 6 digits
  Algorithm: SHA1

  ### backup_codes
  Array of strings
  If Backup Codes are configured on the instance, you can provide them to enable it on the specific user without the need to reset them. You must provide the backup codes in plain format or the corresponding bcrypt digest.

  ### public_metadata
  object
  Metadata saved on the user, that is visible to both your Frontend and Backend APIs

  ### private_metadata
  object
  Metadata saved on the user, that is only visible to your Backend API

  ### unsafe_metadata
  object
  Metadata saved on the user, that can be updated from both the Frontend and Backend APIs. Note: Since this data can be modified from the frontend, it is not guaranteed to be safe.

  ### delete_self_enabled
  boolean or null
  If true, the user can delete themselves with the Frontend API.

  ### create_organization_enabled
  boolean or null
  If true, the user can create organizations with the Frontend API.

  ### created_at
  string
  A custom date/time denoting when the user signed up to the application, specified in RFC3339 format (e.g. 2012-10-20T07:15:20.902Z).
  """
  def update(user_id, params, opts \\ []) do
    HTTP.patch("/v1/users/#{user_id}", params, %{}, opts)
  end

  @doc """
  Delete the specified user
  """
  def delete(user_id, opts \\ []) do
    HTTP.delete("/v1/users/#{user_id}", %{}, opts)
  end

  @doc """
  Marks the given user as banned, which means that all their sessions are revoked and they are not allowed to sign in again.
  """
  def ban(user_id, opts \\ []) do
    HTTP.post("/v1/users/#{user_id}/ban", %{}, %{}, opts)
  end

  @doc """
  Removes the ban mark from the given user.
  """
  def unban(user_id, opts \\ []) do
    HTTP.post("/v1/users/#{user_id}/unban", %{}, %{}, opts)
  end

  @doc """
  Marks the given user as locked, which means they are not allowed to sign in again until the lock expires. Lock duration can be configured in the instance's restrictions settings.
  """
  def lock(user_id, opts \\ []) do
    HTTP.post("/v1/users/#{user_id}/lock", %{}, %{}, opts)
  end

  @doc """
  Removes the lock from the given user.
  """
  def unlock(user_id, opts \\ []) do
    HTTP.post("/v1/users/#{user_id}/unlock", %{}, %{}, opts)
  end

  @doc """
  Update a user's profile image

  # Example

  ```elixir
    file = "~/Downloads/something.jpeg" |> Path.expand() |> File.read!()
    Clerk.User.update_profile_image("my_user_id", file)
  ```
  """
  def update_profile_image(user_id, body, opts \\ []) do
    HTTP.post_form(
      "/v1/users/#{user_id}/profile_image",
      Multipart.Part.text_field(body, :file),
      %{},
      opts
    )
  end

  @doc """
  Delete a user's profile image
  """
  def delete_profile_image(user_id, opts \\ []) do
    HTTP.delete("/v1/users/#{user_id}/profile_image", %{}, opts)
  end

  @doc """
  Update a user's metadata attributes by merging existing values with the provided parameters.

  This endpoint behaves differently than the Update a user endpoint. Metadata values will not be replaced entirely. Instead, a deep merge will be performed. Deep means that any nested JSON objects will be merged as well.

  You can remove metadata keys at any level by setting their value to null.

  ## REQUEST BODY SCHEMA: application/json

  ### public_metadata
  object
  Metadata saved on the user, that is visible to both your frontend and backend. The new object will be merged with the existing value.

  ### private_metadata
  object
  Metadata saved on the user that is only visible to your backend. The new object will be merged with the existing value.

  ### unsafe_metadata
  object
  Metadata saved on the user, that can be updated from both the Frontend and Backend APIs. The new object will be merged with the existing value.

  Note: Since this data can be modified from the frontend, it is not guaranteed to be safe.
  """
  def merge_and_update_user_metadata(user_id, metadata, opts \\ []) do
    HTTP.patch("/v1/users/#{user_id}/metadata", metadata, %{}, opts)
  end

  @doc """
  Fetch the corresponding OAuth access token for a user that has previously authenticated with a particular OAuth provider. For OAuth 2.0, if the access token has expired and we have a corresponding refresh token, the access token will be refreshed transparently the new one will be returned.
  """
  def oauth_access_tokens(user_id, provider, opts \\ []) do
    HTTP.get("/v1/users/#{user_id}/oauth_access_tokens/#{provider}", %{}, opts)
  end

  @doc """
  Retrieve a paginated list of the user's organization memberships

  ## QUERY PARAMETERS

  ### limit
  number [ 1 .. 500 ]
  Default: 10
  Applies a limit to the number of results returned. Can be used for paginating the results together with offset. Must be an integer greater than zero and less than 500. By default, if not supplied, a limit of 10 is used.

  ### offset
  number >= 0
  Default: 0
  Skip the first offset results when paginating. Needs to be an integer greater or equal to zero. To be used in conjunction with limit.
  """
  def list_organization_memberships(user_id, params \\ %{}, opts \\ []) do
    HTTP.get("/v1/users/#{user_id}/organization_memberships", params, opts)
  end

  @doc """
  Check that the user's password matches the supplied input. Useful for custom auth flows and re-verification.
  """
  def verify_password(user_id, password, opts \\ []) do
    HTTP.post("/v1/users/#{user_id}/verify_password", %{"password" => password}, %{}, opts)
  end

  @doc """
  Verify that the provided TOTP or backup code is valid for the user. Verifying a backup code will result it in being consumed (i.e. it will become invalid). Useful for custom auth flows and re-verification.
  """
  def verify_totp(user_id, code, opts \\ []) do
    HTTP.post("/v1/users/#{user_id}/verify_totp", %{"code" => code}, %{}, opts)
  end

  @doc """
  Disable all of a user's MFA methods (e.g. OTP sent via SMS, TOTP on their authenticator app) at once.
  """
  def disable_mfa(user_id, opts \\ []) do
    HTTP.delete("/v1/users/#{user_id}/mfa", %{}, opts)
  end
end
