# frozen_string_literal: true

require "spec_helper"
require "active_support/core_ext"

RSpec.describe CacheIfSlow do
  subject { CacheIfSlow.new(cache: cache, expiry_lookup: expiry_lookup, logger: logger) }
  let(:logger) { Logger.new($stdout) }
  let(:expiry_lookup) do
    [
      {slower_than: 0.5.seconds, expires_in: 1.minute},
      {slower_than: 2, expires_in: 10.minutes},
      {slower_than: 5.seconds, expires_in: 30.minutes}
    ]
  end
  let(:cache) { double("Cache", read: nil) }
  let(:delay_seconds) { 0.01 }
  let(:name) { "unique-cache-key" }
  let(:value) { {response: "value"} }
  let(:block_of_code) do
    proc do
      puts "sleeping for #{delay_seconds}"
      Kernel.sleep delay_seconds
      value
    end
  end
  before(:each) do
    allow(cache).to receive(:write)
  end

  describe "#fetch" do
    context "with cache stored" do
      let(:cache) { double("Cache", read: value) }
      let(:delay_seconds) { 20 }

      it "returns the cached value" do
        expect(cache).to_not receive(:write)
        expect(Kernel).to_not receive(:sleep)
        expect(subject.fetch(name, &block_of_code)).to eq(value)
      end
    end

    context "with no cache stored" do
      context "with 0.6 second block of code" do
        let(:delay_seconds) { 0.6 }

        it "caches response for 1 minute" do
          expect(cache).to receive(:write).with(name, value, {expires_in: 1.minute})
          expect(subject.fetch(name, &block_of_code)).to eq(value)
        end
      end

      context "with 2.1 second block of code" do
        let(:delay_seconds) { 2.1 }

        it "caches response for 1 minute" do
          expect(cache).to receive(:write).with(name, value, {expires_in: 10.minutes})
          expect(subject.fetch(name, &block_of_code)).to eq(value)
        end
      end

      context "with 0.3 second block of code" do
        let(:delay_seconds) { 0.3 }

        it "does not cache response" do
          expect(cache).to_not receive(:write)
          expect(subject.fetch(name, &block_of_code)).to eq(value)
        end
      end
    end
  end
end
