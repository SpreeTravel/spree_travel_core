module Spree
  class PromosController < Spree::BaseController

    rescue_from ActiveRecord::RecordNotFound, :with => :render_404
    helper 'spree/products'

    respond_to :html

    def index

      #para _recomemded_product
      @recomended_product = Spree::Product.includes(:translations).where(:recomended => true).shuffle[0..8]

      @all_promotions = Spree::Promotion.all
      promotions = []
      @all_promotions.each {|p| promotions << p if p.advertise? }

      #respond_to do |format|
      #  format.html # index.html.erb
      #end
    end

    def show
      @promotion = Spree::Promotion.find(params[:id])

      respond_to do |format|
        format.html # index.html.erb
      end
    end
  end

end
