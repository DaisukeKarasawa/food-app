class MigrateExistingDataToUsers < ActiveRecord::Migration[7.0]
  def up
    # Create a default user for existing data
    default_user = User.create!(
      email: 'default@example.com',
      password: 'password123',
      name: 'Default User'
    )
    
    # Assign all existing foods to the default user
    Food.where(user_id: nil).update_all(user_id: default_user.id)
    
    # Assign all existing dishes to the default user
    Dish.where(user_id: nil).update_all(user_id: default_user.id)
    
    # Now make the user_id columns not null
    change_column_null :foods, :user_id, false
    change_column_null :dishes, :user_id, false
  end
  
  def down
    # Make user_id columns nullable again
    change_column_null :foods, :user_id, true
    change_column_null :dishes, :user_id, true
    
    # Remove the default user (this will also remove associated records due to foreign key constraints)
    User.find_by(email: 'default@example.com')&.destroy
  end
end
