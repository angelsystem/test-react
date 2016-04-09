# Do not swallow errors in after_commit/after_rollback callbacks.
Rails.application.config.active_record.raise_in_transactional_callbacks = true
