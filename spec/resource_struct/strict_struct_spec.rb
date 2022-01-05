# frozen_string_literal: true

RSpec.describe ResourceStruct::StrictStruct do
  shared_examples "acts like a strict struct" do
    describe "#intialize" do
      context "with non hash argument" do
        it "raises MethodError" do
          expect { described_class.new("foo") }.to raise_error(ArgumentError)
        end
      end

      context "with nil argument" do
        it "works" do
          expect { described_class.new }.not_to raise_error
          expect { described_class.new(nil) }.not_to raise_error
        end
      end

      context "with hash argument" do
        it "works" do
          expect { struct }.not_to raise_error
        end
      end
    end

    describe ":[]" do
      context "with valid keys" do
        it "is indifferent access" do
          expect(struct.foo).to eq(1)
          expect(struct[:foo]).to eq(1)
          expect(struct["foo"]).to eq(1)
          expect(struct[:bar][0][:baz]).to eq(2)
          expect(struct["bar"][0]["baz"]).to eq(2)
          expect(struct[:bar][0]["baz"]).to eq(2)
          expect(struct["bar"][0][:baz]).to eq(2)
          expect(struct[:cdr]).to eq(false)
          expect(struct["cdr"]).to eq(false)
        end

        it "returns expected results" do
          expect(struct[:foo]).to eq(1)
          expect(struct[:bar, 0]).to eq(described_class.new({ "baz" => 2 }))
          expect(struct[:bar, 0, :baz]).to eq(2)
          expect(struct[:bar, 1]).to eq(3)
          expect(struct[:cdr]).to eq(false)
        end
      end

      context "with missing keys" do
        it "returns nil" do
          expect(struct[:brr]).to eq(nil)
          expect(struct[:brr, :bop]).to eq(nil)
          expect(struct[:bar, 3]).to eq(nil)
          expect(struct[:bar, 3, :dar]).to eq(nil)

          expect { struct[:foo, 0] }.to raise_error(TypeError)
        end
      end
    end

    describe ".name" do
      context "with valid keys" do
        it "return expeceted" do
          expect(struct.foo).to eq(1)
          expect(struct.bar[0]).to eq(described_class.new({ "baz" => 2 }))
          expect(struct.bar[0].baz).to eq(2)
          expect(struct.bar[1]).to eq(3)
        end
      end

      context "with missing keys" do
        it "raises NoMethodError" do
          expect { struct.brr }.to raise_error(NoMethodError)
          expect { struct.daz }.to raise_error(NoMethodError)
        end
      end
    end

    describe ".name?" do
      context "with valid keys" do
        it "return expected" do
          expect(struct.foo?).to eq(true)
          expect(struct.bar?).to eq(true)
          expect(struct.car?).to eq(false)
        end
      end

      context "with missing keys" do
        it "returns false" do
          expect(struct.brr?).to eq(false)
          expect(struct.car?).to eq(false)
          expect(struct.daz?).to eq(false)
        end
      end
    end

    context "marshalling" do
      describe "#marshal_dump" do
        it "is same as hash dump" do
          expect(struct.marshal_dump).to eq({ data: struct.to_hash })
        end
      end

      describe "#marshal_load" do
        it "is inverse of dump" do
          expect(struct.marshal_load({ data: hash })).to eq(struct.to_hash)
          expect(struct.instance_variable_get(:@ro_struct)).to eq({})
        end
      end
    end
  end

  context "with string keys" do
    subject(:struct) { described_class.new(hash) }

    let(:hash) do
      { "foo" => 1, "bar" => [{ "baz" => 2 }, 3], "car" => nil, "cdr" => false }
    end

    include_examples "acts like a strict struct"

    describe "#==" do
      it "is equivalent to hash with symbol keys" do
        expect(struct).to eq(described_class.new({ foo: 1, bar: [{ baz: 2 }, 3], car: nil, cdr: false }))
      end

      it "is equivalent to hash with mixture keys" do
        expect(struct).to eq(described_class.new({ foo: 1, "bar" => [{ baz: 2 }, 3], "car" => nil, "cdr" => false }))
      end
    end

    context "Marshal" do
      subject(:struct) { Marshal.load(Marshal.dump(described_class.new(hash))) }

      include_examples "acts like a strict struct"
    end
  end

  context "with symbol keys" do
    subject(:struct) { described_class.new(hash) }

    let(:hash) do
      { foo: 1, bar: [{ baz: 2 }, 3], car: nil, cdr: false }
    end

    include_examples "acts like a strict struct"

    describe "#==" do
      it "is equivalent to hash with string keys" do
        expect(struct).to eq(
          described_class.new(
            { "foo" => 1, "bar" => [{ "baz" => 2 }, 3], "car" => nil, "cdr" => false }
          )
        )
      end

      it "is equivalent to hash with mixture keys" do
        expect(struct).to eq(
          described_class.new(
            { foo: 1, "bar" => [{ baz: 2 }, 3], "car" => nil, "cdr" => false }
          )
        )
      end
    end

    context "Marshal" do
      subject(:struct) { Marshal.load(Marshal.dump(described_class.new(hash))) }

      include_examples "acts like a strict struct"
    end
  end
end
