# frozen_string_literal: true

class Repository < ApplicationRecord
  # Associations
  belongs_to :user
  has_one :campaign, dependent: :destroy

  # Validations
end
