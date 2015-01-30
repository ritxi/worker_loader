# encoding: utf-8
require 'spec_helper'

describe WorkersLoader::Path do
  let(:base) do
    File.join(File.dirname(__FILE__), '..', '..', 'support', 'dummy')
  end
  subject { described_class.new(base) }

  describe '#files' do
    let(:files) { %w(dummy/bar/base dummy/foo dummy/bar/baz).sort }
    it { expect(subject.files.sort).to eq(files) }
  end

  describe '#class_for' do
    it { expect(subject.class_for('dummy/foo')).to eq(Dummy::Foo) }
    it { expect(subject.class_for('dummy/bar/baz')).to eq(Dummy::Bar::Baz) }
  end

  describe '#queue_for' do
    it { expect(subject.queue_for('dummy/foo')).to eq(:dummy_foo) }
    it { expect(subject.queue_for('dummy/bar/baz')).to eq(:baz_queue) }
  end
end
