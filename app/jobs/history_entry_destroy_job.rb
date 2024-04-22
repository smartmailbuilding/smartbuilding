# app/jobs/history_entry_cleanup_job.rb
class HistoryEntryDestroyJob < ApplicationJob
    queue_as :default
  
    def perform
      HistoryEntry.delete_all
    end
end
  