class AddDefaultAdminUser < ActiveRecord::Migration[7.1]
  def up
    return if User.exists?(email: "cheminko@hotmail.com")

    User.create!(
      username: 'admin',
      email: 'cheminko@hotmail.com',
      password: 'P3nhaligans12!'
    )

    puts "✅ Default admin user created."
  end

  def down
    user = User.find_by(email: "cheminko@hotmail.com")
    user&.destroy
    puts "🗑️ Admin user removed."
  end
end
