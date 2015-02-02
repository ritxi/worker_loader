# encoding: utf-8
require 'spec_helper'

describe WorkersLoader do
  before do
    described_class.workers_paths = []
    described_class.workers = []
  end
  let(:workers_path) do
    File.join(File.dirname(__FILE__), '..', 'support', 'dummy')
  end
  subject { described_class.workers_paths }

  it { expect(subject).to eq([]) }

  describe '::add_path' do
    before { described_class.add_path(workers_path) }

    it { expect(described_class.workers_paths).to eq([workers_path]) }

    context 'dubplicate worker' do
      let(:message) { 'Directory not found: `foo`' }
      it { expect { described_class.add_path('foo') }.to raise_error(message) }
    end
  end

  describe '::find' do
    subject { described_class.find(workers_path) }

    it { expect(subject.sort).to eq([:dummy_foo, :baz_queue].sort) }
  end

  describe '::load_workers!' do
    before do
      described_class.add_path(workers_path)
      described_class.load_workers!
    end
    let(:workers) { [:baz_queue, :dummy_foo].sort }
    it { expect(described_class.workers.sort).to eq(workers) }

    context 'prevent duplicates' do
      let(:message) { "Workers already present! #{workers.join(', ')}" }
      it { expect { described_class.load_workers! }.to raise_error(message) }
    end
  end
end
