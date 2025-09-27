class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  after_create :assign_role

  private

  def assign_role
    # Update column directly to avoid triggering callbacks again
    update_column(:role, 2) # 2 = whatever your default role is
  end
end
