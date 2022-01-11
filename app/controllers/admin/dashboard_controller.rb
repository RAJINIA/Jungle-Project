class Admin::DashboardController < ApplicationController
  def show
    @totalProduct = Product.sum(:quantity)
    @totalCategory = Category.count
  end
end
