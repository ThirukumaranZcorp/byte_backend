class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable

  devise :database_authenticatable,
         :registerable,
         :jwt_authenticatable,
         jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null
         
  after_create :assign_role

  has_one :dashbord, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :contributions, dependent: :destroy
  has_one_attached :signature_image
  after_commit :send_welcome_email, on: :create

  def payout_date_for_month(date = Date.today)
    Date.new(date.year, date.month, payout_day)
  rescue
    nil
  end

  def notify_admin?
    payout_date = payout_date_for_month
    return false unless payout_date
    days_left = (payout_date - Date.today).to_i
    days_left == 2 # Notify 48 hours (2 days) before
  end

  
  private

    def assign_role
      # Update column directly to avoid triggering callbacks again
      update_column(:role, 2) if role.blank? # 2 = whatever your default role is
      # Add one day to issuance_date
      newday = self.issuance_date + 1.day
      # Update payout_day correctly
      update_column(:payout_day, newday.day)
      # Create or find Dashbord record for this user
      Dashbord.find_or_create_by!(
        fee: 3.0,
        min: 3.0,
        max: 5.0,
        user_id: self.id
      )
    end

    def send_welcome_email
      UserMailer.welcome_email(self).deliver_later
    end
end
