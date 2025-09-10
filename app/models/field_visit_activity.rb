class FieldVisitActivity < ApplicationRecord
  broadcasts_refreshes
  belongs_to :field_visit_area
  has_many :participants

  def field_visit_area_name
    field_visit_area&.name
  end 
end
