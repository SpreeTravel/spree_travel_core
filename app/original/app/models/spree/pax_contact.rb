module Spree
  class PaxContact < ActiveRecord::Base

    attr_accessor :client_type

    belongs_to :order

    validates :first_name, :last_name, :sex, :birth, :presence => true

    SEX = [I18n.t('male'), I18n.t('female')]

    validates :sex, :inclusion => SEX

  end
end