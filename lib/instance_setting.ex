defmodule Clerk.InstanceSetting do
  @moduledoc """
  Modify the settings of your instance.
  """

  alias Clerk.HTTP

  @doc """
  Updates the settings of an instance

  ## REQUEST BODY SCHEMA: application/json
  ### test_mode
  boolean or null
  Toggles test mode for this instance, allowing the use of test email addresses and phone numbers. Defaults to true for development instances.

  ### hibp
  boolean or null
  Whether the instance should be using the HIBP service to check passwords for breaches

  ### enhanced_email_deliverability
  boolean or null
  The "enhanced_email_deliverability" feature will send emails from "verifications@clerk.dev" instead of your domain. This can be helpful if you do not have a high domain reputation.

  ### support_email
  string or null
  clerk_js_version
  string or null

  ### development_origin
  string or null
  allowed_origins
  Array of strings
  For browser-like stacks such as browser extensions, Electron, or Capacitor.js the instance allowed origins need to be updated with the request origin value. For Chrome extensions popup, background, or service worker pages the origin is chrome-extension://extension_uiid. For Electron apps the default origin is http://localhost:3000. For Capacitor, the origin is capacitor://localhost.

  ### cookieless_dev
  boolean
  Deprecated
  Whether the instance should operate in cookieless development mode (i.e. without third-party cookies). Deprecated: Please use url_based_session_syncing instead.

  ### url_based_session_syncing
  boolean
  Whether the instance should use URL-based session syncing in development mode (i.e. without third-party cookies).
  """
  def update_settings(params, opts \\ []) do
    HTTP.patch("/v1/instance", params, %{}, opts)
  end

  @doc """
  Updates the restriction settings of an instance

  ## REQUEST BODY SCHEMA: application/json
  ### allowlist
  boolean or null

  ### blocklist
  boolean or null

  ### block_email_subaddresses
  boolean or null

  ### block_disposable_email_domains
  boolean or null
  """
  def update_restrictions(params, opts \\ []) do
    HTTP.patch("/v1/instance/restrictions", params, %{}, opts)
  end

  @doc """
  Updates the organization settings of the instance

  ## REQUEST BODY SCHEMA: application/json
  ### enabled
  boolean or null

  ### max_allowed_memberships
  integer or null

  ### admin_delete_enabled
  boolean or null

  ### domains_enabled
  boolean or null

  ### domains_enrollment_modes
  Array of strings
  Specify which enrollment modes to enable for your Organization Domains. Supported modes are 'automatic_invitation' & 'automatic_suggestion'.

  ### creator_role_id
  string
  Specify what the default organization role is for an organization creator.

  ### domains_default_role_id
  string
  Specify what the default organization role is for the organization domains.
  """
  def update_organization_settings(params, opts \\ []) do
    HTTP.patch("/v1/instance/organization_settings", params, %{}, opts)
  end
end
