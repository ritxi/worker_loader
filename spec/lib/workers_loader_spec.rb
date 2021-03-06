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
    subject { described_class.workers_paths.first }
    it { expect(subject).to be_a(WorkersLoader::Path) }

    context 'dubplicate worker' do
      let(:message) { 'Directory not found: `foo`' }
      it { expect { described_class.add_path('foo') }.to raise_error(message) }
    end
  end

  describe '::load_workers!' do
    let(:workers) { [:baz_queue, :dummy_foo].sort }

    context 'load workers' do
      before do
        described_class.add_path(workers_path)
        described_class.load_workers!
      end

      it { expect(described_class.workers.sort).to eq(workers) }
    end

    context 'load mailer' do
      before do
        described_class.resque_mailer!
        described_class.load_workers!
      end

      it { expect(described_class.workers.sort).to include(:mailer) }
    end

    context 'prevent duplicates' do
      before do
        described_class.add_path(workers_path)
        described_class.load_workers!
      end

      let(:message) { "Workers already present! #{workers.join(', ')}" }
      it { expect { described_class.load_workers! }.to raise_error(message) }
    end
  end
end
