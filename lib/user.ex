defmodule Clerk.User do
  alias Clerk.HTTP

  def get(user_id, opts \\ []) do
    HTTP.get("/v1/users/#{user_id}", %{}, opts)
  end

  @doc """
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

  If you need support for any particular hashing algorithm, please let us know.

  Note: for password hashers considered insecure (at this moment MD5 and SHA256), the corresponding user password hashes will be transparently migrated to Bcrypt (a secure hasher) upon the user's first successful password sign in. Insecure schemes are marked with (insecure) in the list below.

  Each of the supported hashers expects the incoming digest to be in a particular format. Specifically:

  bcrypt: The digest should be of the following form:

  $<algorithm version>$<cost>$<salt & hash>

  bcrypt_sha256_django: This is the Django-specific variant of Bcrypt, using SHA256 hashing function. The format should be as follows (as exported from Django):

  bcrypt_sha256$$<algorithm version>$<cost>$<salt & hash>

  md5 (insecure): The digest should follow the regular form e.g.:

  5f4dcc3b5aa765d61d8327deb882cf99

  pbkdf2_sha256: This is the PBKDF2 algorithm using the SHA256 hashing function. The format should be as follows:

  pbkdf2_sha256$<iterations>$<salt>$<hash>

  Note: Both the salt and the hash are expected to be base64-encoded.

  pbkdf2_sha256_django: This is the Django-specific variant of PBKDF2 and the digest should have the following format (as exported from Django):

  pbkdf2_sha256$<iterations>$<salt>$<hash>

  Note: The salt is expected to be un-encoded, the hash is expected base64-encoded.

  pbkdf2_sha1: This is similar to pkbdf2_sha256_django, but with two differences:

  uses sha1 instead of sha256
  accepts the hash as a hex-encoded string
  The format is the following:

  pbkdf2_sha1$<iterations>$<salt>$<hash-as-hex-string>

  phpass: Portable public domain password hashing framework for use in PHP applications. Digests hashed with phpass have the following sections:

  The format is the following:

  $P$<rounds><salt><encoded-checksum>

  $P$ is the prefix used to identify phpass hashes.
  rounds is a single character encoding a 6-bit integer representing the number of rounds used.
  salt is eight characters drawn from [./0-9A-Za-z], providing a 48-bit salt.
  checksum is 22 characters drawn from the same set, encoding the 128-bit checksum with MD5.
  scrypt_firebase: The Firebase-specific variant of scrypt. The value is expected to have 6 segments separated by the $ character and include the following information:

  hash: The actual Base64 hash. This can be retrieved when exporting the user from Firebase. salt: The salt used to generate the above hash. Again, this is given when exporting the user. signer key: The base64 encoded signer key. salt separator: The base64 encoded salt separator. rounds: The number of rounds the algorithm needs to run. memory cost: The cost of the algorithm run

  The first 2 (hash and salt) are per user and can be retrieved when exporting the user from Firebase. The other 4 values (signer key, salt separator, rounds and memory cost) are project-wide settings and can be retrieved from the project's password hash parameters.

  Once you have all these, you can combine it in the following format and send this as the digest in order for Clerk to accept it:

  <hash>$<salt>$<signer key>$<salt separator>$<rounds>$<memory cost>

  argon2i: Algorithms in the argon2 family generate digests that encode the following information:

  version (v): The argon version, version 19 is assumed memory (m): The memory used by the algorithm (in kibibytes) iterations (t): The number of iterations to perform parallelism (p): The number of threads to use

  Parts are demarcated by the $ character, with the first part identifying the algorithm variant. The middle part is a comma-separated list of the encoding options (memory, iterations, parallelism). The final part is the actual digest.

  $argon2i$v=19$m=4096,t=3,p=1$4t6CL3P7YiHBtwESXawI8Hm20zJj4cs7/4/G3c187e0$m7RQFczcKr5bIR0IIxbpO2P0tyrLjf3eUW3M3QSwnLc

  argon2id: See the previous algorithm for an explanation of the formatting.

  For the argon2id case, the value of the algorithm in the first part of the digest is argon2id:

  $argon2id$v=19$m=64,t=4,p=8$Z2liZXJyaXNo$iGXEpMBTDYQ8G/71tF0qGjxRHEmR3gpGULcE93zUJVU

  sha256 (insecure): The digest should be a 64-length hex string, e.g.:

  9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08

  Enum: "argon2i" "argon2id" "bcrypt" "bcrypt_sha256_django" "md5" "pbkdf2_sha256" "pbkdf2_sha256_django" "pbkdf2_sha1" "phpass" "scrypt_firebase" "sha256"

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
end
