defmodule FirebirdexTest do
  use ExUnit.Case, async: true

  @opts TestHelpers.opts()

  describe "connect" do
    opts = @opts
    {:ok, conn} = Firebirdex.start_link(opts)

    {:ok, %Firebirdex.Result{} = result} = Firebirdex.query(conn,
      "SELECT
        1 AS a,
        CAST('Str' AS VARCHAR(3)) AS b,
        1.23 AS c,
        CAST(1.23 AS DOUBLE PRECISION) AS d,
        NULL AS E
        FROM RDB$DATABASE", [])

    assert result.columns == ["A", "B", "C", "D", "E"]
    assert result.rows == [[1, "Str", Decimal.new("1.23"), 1.23, :nil]]

    {:ok, %Firebirdex.Result{} = result2} = Firebirdex.query(conn,
      "SELECT count(*) from rdb$relations where rdb$system_flag = ?", [0])
    assert result2.rows == [[0]]
  end

end
