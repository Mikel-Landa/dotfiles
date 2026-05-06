local hunks = require("config.my.diff.hunks")

describe("hunks.parse", function()
  it("returns empty list for nil file", function()
    assert.are.same({}, hunks.parse(nil))
  end)

  it("returns empty list for file with no hunks and no patch", function()
    assert.are.same({}, hunks.parse({}))
  end)

  it("parses atlas-shape hunks (file.hunks list of { header, ... })", function()
    local file = {
      hunks = {
        { header = "@@ -1,3 +1,5 @@" },
        { header = "@@ -10,2 +12,4 @@ tail" },
      },
    }
    assert.are.same({
      { left_start = 1, left_count = 3, right_start = 1, right_count = 5 },
      { left_start = 10, left_count = 2, right_start = 12, right_count = 4 },
    }, hunks.parse(file))
  end)

  it("treats unparseable atlas hunks as empty and falls through", function()
    local file = {
      hunks = { { header = "garbage" } },
      patch = "@@ -7,1 +7,1 @@\n-foo\n+bar\n",
    }
    assert.are.same({
      { left_start = 7, left_count = 1, right_start = 7, right_count = 1 },
    }, hunks.parse(file))
  end)

  it("parses raw patch fallback (file.patch)", function()
    local file = {
      patch = "@@ -1,3 +1,5 @@\n some\n@@ -20 +22 @@\n",
    }
    assert.are.same({
      { left_start = 1, left_count = 3, right_start = 1, right_count = 5 },
      { left_start = 20, left_count = 1, right_start = 22, right_count = 1 },
    }, hunks.parse(file))
  end)

  it("parses raw patch fallback (file.raw)", function()
    local file = { raw = "@@ -5 +5,2 @@" }
    assert.are.same({
      { left_start = 5, left_count = 1, right_start = 5, right_count = 2 },
    }, hunks.parse(file))
  end)

  it("defaults missing count to 1", function()
    local file = { hunks = { { header = "@@ -42 +42 @@" } } }
    assert.are.same({
      { left_start = 42, left_count = 1, right_start = 42, right_count = 1 },
    }, hunks.parse(file))
  end)
end)

describe("hunks.contains", function()
  local h = {
    { left_start = 1, left_count = 3, right_start = 1, right_count = 5 },
    { left_start = 20, left_count = 2, right_start = 22, right_count = 4 },
  }

  it("returns false for empty hunks", function()
    assert.is_false(hunks.contains({}, 1, 1, "RIGHT"))
    assert.is_false(hunks.contains(nil, 1, 1, "RIGHT"))
  end)

  it("matches RIGHT side range", function()
    assert.is_true(hunks.contains(h, 1, 1, "RIGHT"))
    assert.is_true(hunks.contains(h, 1, 5, "RIGHT"))
    assert.is_true(hunks.contains(h, 22, 25, "RIGHT"))
  end)

  it("matches LEFT side range", function()
    assert.is_true(hunks.contains(h, 1, 3, "LEFT"))
    assert.is_true(hunks.contains(h, 20, 21, "LEFT"))
  end)

  it("rejects ranges outside any hunk", function()
    assert.is_false(hunks.contains(h, 6, 6, "RIGHT"))
    assert.is_false(hunks.contains(h, 4, 4, "LEFT"))
    assert.is_false(hunks.contains(h, 100, 200, "RIGHT"))
  end)

  it("rejects ranges that span past hunk end", function()
    assert.is_false(hunks.contains(h, 1, 6, "RIGHT"))
    assert.is_false(hunks.contains(h, 3, 4, "LEFT"))
  end)

  it("treats LEFT and RIGHT independently", function()
    local only_right = { { left_start = 0, left_count = 0, right_start = 10, right_count = 3 } }
    assert.is_true(hunks.contains(only_right, 11, 11, "RIGHT"))
    assert.is_false(hunks.contains(only_right, 11, 11, "LEFT"))
  end)
end)
