# encoding: utf-8
require 'spec_helper'

describe WorkersLoader::Path do
  let(:support_path) do
    File.join(File.dirname(__FILE__), '..', '..', 'support')
  end

  context 'without parent' do
    let(:base) { File.join(support_path, 'data') }
    subject { described_class.new(base, false) }

    describe '#base' do
      it { expect(subject.base).to eq(base) }
    end

    describe '#base_with_parent' do
      it { expect(subject.base_with_parent).to eq(base) }
    end

    describe '#parent' do
      it { expect(subject.parent).to be_nil }
    end

    describe '#files' do
      let(:files) { %w(user reports/usage).sort }
      it { expect(subject.files.sort).to eq(files) }
    end

    describe '#class_for' do
      it { expect(subject.class_for('user')).to eq(User) }
      it { expect(subject.class_for('reports/usage')).to eq(Reports::Usage) }
    end

    describe '#queue_for' do
      it { expect(subject.queue_for('user')).to eq(:user_queue) }
      it { expect(subject.queue_for('reports/usage')).to eq(:usage_queue) }
    end
  end

  context 'with parent' do
    let(:base) { File.join(support_path, 'dummy') }
    let(:base_without_parent) { support_path }

    subject { described_class.new(base) }

    describe '#base' do
      it { expect(subject.base).to eq(base_without_parent) }
    end

    describe '#base_with_parent' do
      it { expect(subject.base_with_parent).to eq(base) }
    end

    describe '#parent' do
      it { expect(subject.parent).to eq('dummy') }
    end

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
end
