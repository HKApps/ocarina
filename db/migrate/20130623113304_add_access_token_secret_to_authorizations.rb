class AddAccessTokenSecretToAuthorizations < ActiveRecord::Migration
  def change
    add_column :authorizations, :access_token_secret, :string
  end
end
