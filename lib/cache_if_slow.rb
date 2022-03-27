# frozen_string_literal: true

require "rails"
require "cache_if_slow/version"

class CacheIfSlow
  attr_accessor :logger
  def initialize(cache: Rails.cache, expiry_lookup: nil, logger: Rails.logger)
    @cache = cache
    @logger = logger
    if expiry_lookup.present?
      expiry_lookup.each do |v|
        raise ArgumentError, "`slower_than` if required for all entries in `expiry_lookup`" if v[:slower_than].blank?
        raise ArgumentError, "`expires_in` if required for all entries in `expiry_lookup`" if v[:expires_in].blank?
      end
      @expiry_lookup = expiry_lookup.sort_by { |v| -v[:slower_than] }
    end
  end

  def fetch(name, max_seconds: nil, **options)
    unless block_given?
      raise ArgumentError, "Missing block: Calling `CacheIfSlow#fetch` requires a block."
    end

    if @expiry_lookup.blank? && max_seconds.nil?
      raise ArgumentError, "`max_seconds` is required if `expiry_lookup` is not present."
    end
    max_seconds = @expiry_lookup[-1][:slower_than] if max_seconds.nil? || @expiry_lookup[-1][:slower_than] < max_seconds

    value = @cache.read(name, options)
    return value unless value.nil?

    start = Time.now
    value = yield(name)
    total_time = Time.now - start

    if total_time > max_seconds && @cache.read(name, options).nil?
      expires_in = lookup_expiry(total_time, options)
      options[:expires_in] = expires_in
      @logger.info "CacheIfSlow :: Storing '#{name}' as #{total_time} > #{max_seconds} expires_in: #{expires_in}"
      @cache.write(name, value, options)
    end
    value
  end

  class << self
    def fetch(name, max_seconds:, **options, &block)
      new.fetch(name, max_seconds: max_seconds, **options, &block)
    end
  end

  private

  def lookup_expiry(total_time, options)
    if @expiry_lookup.present?
      expires_in = @expiry_lookup.find { |v| v[:slower_than] < total_time }.try(:[], :expires_in)
      expires_in || options[:expires_in]
    else
      options[:expires_in]
    end
  end
end
