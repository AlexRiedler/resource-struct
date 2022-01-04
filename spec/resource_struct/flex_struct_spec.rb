# frozen_string_literal: true

require "json"

RSpec.describe ResourceStruct::FlexStruct do
  shared_examples "acts like a loose struct" do
    describe "#intialize" do
      context "with non hash argument" do
        it "raises MethodError" do
          expect { described_class.new("foo") }.to raise_error(ArgumentError)
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
        end

        it "returns expected results" do
          expect(struct[:foo]).to eq(1)
          expect(struct[:bar, 0]).to eq(described_class.new({ "baz" => 2 }))
          expect(struct[:bar, 0, :baz]).to eq(2)
          expect(struct[:bar, 1]).to eq(3)
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
        it "returns nil" do
          expect(struct.brr).to be_nil
          expect(struct.daz).to be_nil
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

    describe "#[]=" do
      it "allows creation of new keys" do
        struct[:hamburger] = 1
        expect(struct.hamburger).to eq(1)

        struct[:icecream] = { foo: { bar: 2 } }
        expect(struct.icecream.foo.bar).to eq(2)

        struct.donut = { foo: { bar: 3 } }
        expect(struct.donut.foo.bar).to eq(3)
      end

      context "with key collisions" do
        context "with symbol as primary key" do
          it "properly overrides" do
            struct[:hamburger] = 1
            expect(struct.hamburger).to eq(1)
            struct["hamburger"] = 2
            expect(struct.hamburger).to eq(2)
            struct.hamburger = 3
            expect(struct.hamburger).to eq(3)
          end
        end

        context "with strings as primary key" do
          it "properly overrides" do
            struct["hamburger"] = 1
            expect(struct.hamburger).to eq(1)
            struct[:hamburger] = 2
            expect(struct.hamburger).to eq(2)
            struct.hamburger = 3
            expect(struct.hamburger).to eq(3)
          end
        end
      end

      it "handles modification of existing keys" do
        struct[:chocolate] = { foo: { bar: 1 } }
        previous_value = struct.chocolate
        struct[:chocolate] = { foo: { bar: 2 } }

        expect(previous_value.foo.bar).to eq(1)
        expect(struct.chocolate.foo.bar).to eq(2)
      end

      it "handles struct by converting to same type of resource-struct" do
        struct[:chocolate] = described_class.new({ foo: { bar: 1 } })
        expect(struct.chocolate.foo.bar).to eq(1)
        expect(struct.chocolate.class.name).to eq(described_class.name)
        expect(struct.chocolate.to_h.class.name).to eq(Hash.name)
      end
    end
  end

  context "with string keys" do
    subject(:struct) { described_class.new(hash) }

    let(:hash) do
      { "foo" => 1, "bar" => [{ "baz" => 2 }, 3], "car" => nil }
    end

    include_examples "acts like a loose struct"

    describe "#==" do
      it "is equivalent to hash with symbol keys" do
        expect(struct).to eq(described_class.new({ foo: 1, bar: [{ baz: 2 }, 3], car: nil }))
      end
    end

    context "JSON.parse" do
      subject(:struct) { JSON.parse(hash.to_json, object_class: described_class) }

      include_examples "acts like a loose struct"
    end
  end

  context "with symbol keys" do
    subject(:struct) { described_class.new(hash) }

    let(:hash) do
      { foo: 1, bar: [{ baz: 2 }, 3], car: nil }
    end

    include_examples "acts like a loose struct"

    describe "#==" do
      it "is equivalent to hash with string keys" do
        expect(struct).to eq(described_class.new({ "foo" => 1, "bar" => [{ "baz" => 2 }, 3], "car" => nil }))
      end
    end

    context "JSON.parse" do
      subject(:struct) { JSON.parse(hash.to_json, object_class: described_class) }

      include_examples "acts like a loose struct"
    end
  end
end
