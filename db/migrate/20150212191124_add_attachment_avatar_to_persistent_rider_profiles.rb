class AddAttachmentAvatarToPersistentRiderProfiles < ActiveRecord::Migration
  def self.up
    change_table :persistent_rider_profiles do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :persistent_rider_profiles, :avatar
  end
end
