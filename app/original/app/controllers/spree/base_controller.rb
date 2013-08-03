class Spree::BaseController < ApplicationController
  include Spree::Core::ControllerHelpers
  include Spree::Core::RespondWith
  #before_filter :authenticate_user!  #TODO Autenticaci'on general'
  before_filter :promotions

  def promotions
    all_promotions = Spree::Promotion.all
    @promotions = []
    all_promotions.each { |p| @promotions << p if p.advertise? }
  end

end
