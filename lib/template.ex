defmodule Clerk.Template do
  @moduledoc """
  Email & SMS templates allow you to customize the theming and wording of emails & SMS messages that are sent by your instance.

  https://clerk.com/docs/authentication/email-sms-templates
  """

  alias Clerk.HTTP

  @doc """
  Returns a list of all templates. The templates are returned sorted by position.

  template_type
  required
  string
  The type of templates to list (email or SMS)

  Enum: "email" "sms"
  """
  def list(template_type, opts \\ []) do
    HTTP.get("/v1/templates/#{template_type}", %{}, opts)
  end

  @doc """
  Returns the details of a template
  """
  def get(template_type, id, opts \\ []) do
    HTTP.get("/v1/templates/#{template_type}/#{id}", %{}, opts)
  end

  @doc """
  Updates the existing template of the given type and slug

  ## REQUEST BODY SCHEMA: application/json
  ### name
  string
  The user-friendly name of the template

  ### subject
  string or null
  The email subject. Applicable only to email templates.

  ### markup
  string or null
  The editor markup used to generate the body of the template

  ### body
  string
  The template body before variable interpolation

  ### delivered_by_clerk
  boolean or null
  Whether Clerk should deliver emails or SMS messages based on the current template

  ### from_email_name
  string
  The local part of the From email address that will be used for emails. For example, in the address 'hello@example.com', the local part is 'hello'. Applicable only to email templates.
  """
  def update(template_type, id, params, opts \\ []) do
    HTTP.put("/v1/templates/#{template_type}/#{id}", params, %{}, opts)
  end

  @doc """
  Reverts an updated template to its default state
  """
  def revert(template_type, id, opts \\ []) do
    HTTP.post("/v1/templates/#{template_type}/#{id}/revert", %{}, %{}, opts)
  end

  @doc """
  Returns a preview of a template for a given template_type, slug and body

  ## REQUEST BODY SCHEMA: application/json
  Required parameters

  ### subject
  string or null
  The email subject. Applicable only to email templates.

  ### body
  string
  The template body before variable interpolation

  ### from_email_name
  string
  The local part of the From email address that will be used for emails. For example, in the address 'hello@example.com', the local part is 'hello'. Applicable only to email templates.
  """
  def preview(template_type, id, params, opts \\ []) do
    HTTP.post("/v1/templates/#{template_type}/#{id}/preview", params, %{}, opts)
  end

  @doc """
  Toggles the delivery of a template for a given template_type and slug

  ## REQUEST BODY SCHEMA: application/json
  ### delivered_by_clerk
  boolean or null
  Whether Clerk should deliver emails or SMS messages based on the current template
  """
  def toggle_delivery(template_type, id, params, opts \\ []) do
    HTTP.post("/v1/templates/#{template_type}/#{id}/toggle_delivery", params, %{}, opts)
  end
end
