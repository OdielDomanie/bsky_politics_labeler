defmodule BskyPoliticsLabeler.Base32Sortable do
  @moduledoc """
  The high-level semantics of a TID are:
  * 64-bit integer
  * big-endian byte ordering
  * encoded as base32-sortable. That is, encoded with characters 234567abcdefghijklmnopqrstuvwxyz
  * no special padding characters (like =) are used, but all digits are always encoded,
    so length is always 13 ASCII characters. The TID corresponding to integer zero is 2222222222222.
  """

  def decode!(string) when byte_size(string) == 13 do
    do_decode(string, 12)
  end

  @max_63 2 ** 63

  def encode!(int) when int in 0..@max_63 do
    <<
      x00::4,
      x01::5,
      x02::5,
      x03::5,
      x04::5,
      x05::5,
      x06::5,
      x07::5,
      x08::5,
      x09::5,
      x10::5,
      x11::5,
      x12::5
    >> = <<int::64>>

    [
      value_character(x00),
      value_character(x01),
      value_character(x02),
      value_character(x03),
      value_character(x04),
      value_character(x05),
      value_character(x06),
      value_character(x07),
      value_character(x08),
      value_character(x09),
      value_character(x10),
      value_character(x11),
      value_character(x12)
    ]
    |> List.to_string()
  end

  defp do_decode(<<c::integer-size(8), rest::binary>>, remaining) when remaining >= 0 do
    if remaining == 12 and not (c in ?2..?7 or c in ?a..?j),
      do: raise("Invalid base32-sortable: first character")

    val = character_value(c)

    val * 32 ** remaining + do_decode(rest, remaining - 1)
  end

  defp do_decode(<<>>, -1), do: 0

  defp character_value(c) do
    cond do
      c in ?2..?7 -> c - ?2
      c in ?a..?z -> c - ?a + 6
    end
  end

  defp value_character(val) do
    cond do
      val in 0..5 -> ?2 + val
      val in 6..31 -> ?a + val - 6
    end
  end
end
