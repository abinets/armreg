class ChangeOrganizationIdToAllowNullInParticipants < ActiveRecord::Migration[7.2]
  def change
    change_column_null :participants, :organization_id, true

  end
end
