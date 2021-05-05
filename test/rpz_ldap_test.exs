defmodule RpzLdapTest do
  use ExUnit.Case

  describe "#connect" do
    test "it returns {:ok, pid} tupple" do
      assert {:ok, pid} = RpzLdap.connect()
      assert Process.alive?(pid) == true
    end
  end
end
