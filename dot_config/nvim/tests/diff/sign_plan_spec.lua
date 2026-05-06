local sign_plan = require("config.my.diff.sign_plan")

local function root(opts)
  return vim.tbl_extend("force", {
    id = opts.id or 1,
    anchor = { side = opts.side or "RIGHT", line = opts.line or 5 },
    path = opts.path or "src/main.lua",
    body = opts.body or "x",
    user = "alice",
    created_at = nil,
    pending = opts.pending or false,
    in_reply_to_id = nil,
    _raw = nil,
  }, opts.overrides or {})
end

local function reply(opts)
  local r = root(opts)
  r.in_reply_to_id = opts.parent or 1
  return r
end

describe("sign_plan.plan", function()
  it("returns empty plan for empty comment list", function()
    assert.are.same({}, sign_plan.plan({}, "src/main.lua", "RIGHT", 100))
  end)

  it("places a sign on a thread root for the matching path + side", function()
    local plan = sign_plan.plan({ root({ id = 1, line = 5 }) }, "src/main.lua", "RIGHT", 100)
    assert.is_not_nil(plan[5])
    assert.equals("●", plan[5].icon)
    assert.equals("DiagnosticInfo", plan[5].hl)
  end)

  it("ignores replies — only thread roots place signs", function()
    local plan = sign_plan.plan({
      reply({ id = 2, parent = 1, line = 7 }),
    }, "src/main.lua", "RIGHT", 100)
    assert.are.same({}, plan)
  end)

  it("filters by path", function()
    local plan = sign_plan.plan({
      root({ id = 1, path = "other.lua", line = 5 }),
    }, "src/main.lua", "RIGHT", 100)
    assert.are.same({}, plan)
  end)

  it("filters by side", function()
    local plan = sign_plan.plan({
      root({ id = 1, side = "LEFT", line = 5 }),
    }, "src/main.lua", "RIGHT", 100)
    assert.are.same({}, plan)
    plan = sign_plan.plan({
      root({ id = 1, side = "LEFT", line = 5 }),
    }, "src/main.lua", "LEFT", 100)
    assert.is_not_nil(plan[5])
  end)

  it("drops anchors past line_count or below 1", function()
    local plan = sign_plan.plan({
      root({ id = 1, line = 200 }),
      root({ id = 2, line = 0 }),
      root({ id = 3, line = 50 }),
    }, "src/main.lua", "RIGHT", 100)
    assert.is_nil(plan[200])
    assert.is_nil(plan[0])
    assert.is_not_nil(plan[50])
  end)

  it("uses pending sign when comment is pending", function()
    local plan = sign_plan.plan({
      root({ id = 1, line = 5, pending = true }),
    }, "src/main.lua", "RIGHT", 100)
    assert.equals("○", plan[5].icon)
    assert.equals("DiagnosticHint", plan[5].hl)
  end)

  it("pending wins when both pending and published roots share a line", function()
    local plan = sign_plan.plan({
      root({ id = 1, line = 5, pending = false }),
      root({ id = 2, line = 5, pending = true }),
    }, "src/main.lua", "RIGHT", 100)
    assert.equals("○", plan[5].icon)
  end)

  it("collapses multiple roots on same line to a single sign", function()
    local plan = sign_plan.plan({
      root({ id = 1, line = 5 }),
      root({ id = 2, line = 5 }),
    }, "src/main.lua", "RIGHT", 100)
    local count = 0
    for _ in pairs(plan) do count = count + 1 end
    assert.equals(1, count)
  end)

  it("returns empty for nil comments", function()
    assert.are.same({}, sign_plan.plan(nil, "src/main.lua", "RIGHT", 100))
  end)
end)
