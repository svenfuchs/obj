describe Obj do
  subject { const.new(*args) }

  def wrong_number_of_arguments(given, expected)
    args = RUBY_VERSION < '2.3' ? '(%s for %s)' : '(given %s, expected %s)'
    "wrong number of arguments #{args % [given, expected]}"
  end

  describe 'no defaults' do
    let(:const) { Obj.new(:one, :two) }

    describe 'given sufficient args' do
      let(:args)  { [1, 2] }

      it { should respond_to :one }
      it { should respond_to :one= }
      it { should respond_to :one? }
      it { should respond_to :two }
      it { should respond_to :two= }
      it { should respond_to :two? }

      it { should be_one }
      it { should be_two }

      it { should have_attributes one: 1 }
      it { should have_attributes two: 2 }
    end

    describe 'given nil' do
      let(:args)  { [1, nil] }

      it { should be_one }
      it { should_not be_two }

      it { should have_attributes one: 1 }
      it { should have_attributes two: nil }
    end

    describe 'no arguments' do
      let(:msg) { wrong_number_of_arguments(0, 2) }
      it { expect { const.new }.to raise_error ArgumentError, msg }
    end

    describe 'missing argument' do
      let(:msg) { wrong_number_of_arguments(1, 2) }
      it { expect { const.new(1) }.to raise_error ArgumentError, msg }
    end

    describe 'too many arguments' do
      let(:msg) { wrong_number_of_arguments(3, 2) }
      it { expect { const.new(1, 2, 3) }.to raise_error ArgumentError, msg }
    end
  end

  describe 'a default value' do
    let(:const) { Obj.new(:one, two: :default) }

    describe 'given one arg' do
      let(:args) { [1] }

      it { should respond_to :one }
      it { should respond_to :one= }
      it { should respond_to :one? }

      it { should respond_to :two }
      it { should respond_to :two= }
      it { should respond_to :two? }

      it { should be_one }
      it { should be_two }

      it { should have_attributes one: 1 }
      it { should have_attributes two: :default }
    end

    describe 'given two args' do
      let(:args) { [1, 2] }

      it { should be_one }
      it { should be_two }

      it { should have_attributes one: 1 }
      it { should have_attributes two: 2 }
    end

    describe 'given nil' do
      let(:args)  { [1, nil] }

      it { should be_one }
      it { should be_two }

      it { should have_attributes one: 1 }
      it { should have_attributes two: :default }
    end

    describe 'no arguments' do
      let(:msg) { wrong_number_of_arguments(0, '1..2') }
      it { expect { const.new }.to raise_error ArgumentError, msg }
    end

    describe 'too many arguments' do
      let(:msg) { wrong_number_of_arguments(3, '1..2') }
      it { expect { const.new(1, 2, 3) }.to raise_error ArgumentError, msg }
    end
  end

  describe 'modules' do
    subject { const.new }

    describe 'included to Obj' do
      let(:const) { Obj.new }

      before { Obj.include(Module.new { def foo; :foo end }) }

      it { should respond_to :foo }
    end

    describe 'included to an Obj instance' do
      let(:const) do
        Obj.new do
          include Module.new { def bar; :bar end }
        end
      end

      it { should respond_to :bar }
    end

    describe 'included to a subclass' do
      let(:const) do
        Class.new(Obj.new) do
          include Module.new { def bar; :bar end }
        end
      end

      it { should respond_to :bar }
    end
  end
end
