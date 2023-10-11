class Order < ApplicationRecord
  include ActiveModel::Validations
  belongs_to :user
  validates :total, numericality: { greater_than_or_equal_to: 0 }
  validates :total, presence: true
  has_many :placements, dependent: :destroy
  has_many :products, through: :placements
  before_validation :set_total!
  validates_with EnoughProductsValidator

  def build_placements_with_product_ids_and_quantities(product_ids_and_quantites)
    product_ids_and_quantites.each do |product_id_and_quantity|
      placement = placements.build(product_id: product_id_and_quantity[:product_id],
                                   quantity: product_id_and_quantity[:quantity])
      yield placement if block_given?
    end
  end

  def set_total!
    self.total = self.placements.map { |placement| placement.product.price * placement.quantity }.sum
  end
end
