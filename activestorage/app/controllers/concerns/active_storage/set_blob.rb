# frozen_string_literal: true

module ActiveStorage::SetBlob # :nodoc:
  extend ActiveSupport::Concern

  included do
    before_action :set_blob
  end

  private
    def set_blob
      puts blob_scope.all.map(&:attributes)
      Rollbar.info("set_blob", params: params, all: blob_scope.all.map(&:attributes))
      @blob = blob_scope.find_signed!(params[:signed_blob_id] || params[:signed_id])
      Rollbar.info("this is the blob", blob: @blob)
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      puts $!.message
      puts $!.backtrace
      Rollbar.error($!)
      head :not_found
    end

    def blob_scope
      ActiveStorage::Blob
    end
end
