defmodule BskyPoliticsLabeler.Base32SortableTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  alias BskyPoliticsLabeler.Base32Sortable

  test "Corresponding to integer zero is 2222222222222" do
    assert 0 === Base32Sortable.decode!("2222222222222")
  end

  test "Converts some modern time" do
    assert 1_792_264_486_591_488_002 == Base32Sortable.decode!("3lrvb3s3hes24")
  end

  test "Encodes some modern time" do
    assert "3lrvb3s3hes24" == Base32Sortable.encode!(1_792_264_486_591_488_002)
  end

  def decoded_gen() do
    gen all <<int_rest::63>> <- bitstring(length: 63) do
      <<int::64>> = <<0::1, int_rest::63>>
      int
    end
  end

  def encoded_gen() do
    gen all <<int_rest::63>> <- bitstring(length: 63) do
      <<int::64>> = <<0::1, int_rest::63>>
      Base32Sortable.encode!(int)
    end
  end

  property "decoded is 64-bit u-integer" do
    check all encoded <- encoded_gen() do
      dec = Base32Sortable.decode!(encoded)

      assert dec >= 0
      assert dec < 2 ** 64
    end
  end

  property "decoded top bit always zero" do
    check all encoded <- encoded_gen() do
      dec = Base32Sortable.decode!(encoded)

      assert <<0::1, rest::63>> = <<dec::64>>
      assert rest == dec
    end
  end

  property "encoded with certain characters" do
    check all decoded <- decoded_gen() do
      enc = Base32Sortable.encode!(decoded)

      chars = ~c"234567abcdefghijklmnopqrstuvwxyz"

      assert enc |> String.to_charlist() |> Enum.all?(&(&1 in chars))
    end
  end

  property "encoded with 13 characters" do
    check all decoded <- decoded_gen() do
      enc = Base32Sortable.encode!(decoded)

      assert String.length(enc) == 13
    end
  end

  property "encoded start with certain characters" do
    check all decoded <- decoded_gen() do
      enc = Base32Sortable.encode!(decoded)

      valid = "234567abcdefghij"

      first = String.first(enc)
      assert String.contains?(valid, first)
    end
  end

  property "decode -> encode roundtrip" do
    check all gen_encoded <- encoded_gen() do
      dec = Base32Sortable.decode!(gen_encoded)
      enc = Base32Sortable.encode!(dec)

      assert enc === gen_encoded
    end
  end
end
