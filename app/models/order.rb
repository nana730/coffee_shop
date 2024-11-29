class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items, dependent: :destroy

  enum status: { "オーナー確認待ち": 0, "オーナー確認済み": 1 }
  
  validates :name, presence: true
  validates :postal_code, presence: true
  validates :prefecture, presence: true
  validates :address, presence: true
  validates :postage, presence: true
  validates :total_amount, presence: true
  validates :status, presence: true
    # ステータスのスコープ
    scope :waiting_order, -> { where(status: :オーナー確認待ち) }
    scope :confirm_order, -> { where(status: :オーナー確認済み) }
    scope :today_orders, -> { where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day) }

    def subtotal
      order_items.sum(&:subtotal)
    end
end
