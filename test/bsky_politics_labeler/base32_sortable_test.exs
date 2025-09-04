defmodule BskyPoliticsLabeler.Base32SortableTest do
  alias BskyPoliticsLabeler.Base32Sortable
  use ExUnit.Case, async: true

  test "Corresponding to integer zero is 2222222222222" do
    assert 0 === Base32Sortable.decode!("2222222222222")
  end

  test "Converts some modern time" do
    assert 1_792_264_486_591_488_002 == Base32Sortable.decode!("3lrvb3s3hes24")
  end

  test "Encodes some modern time" do
    assert "3lrvb3s3hes24" == Base32Sortable.encode!(1_792_264_486_591_488_002)
  end
end
