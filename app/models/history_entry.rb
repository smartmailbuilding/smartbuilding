class HistoryEntry < ApplicationRecord
  validates :saveCards, uniqueness: true  
end