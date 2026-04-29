-- Diff <leader>… keymap declarations in lua/ against docs/keymaps.md.
-- Run from the config root: `nvim --headless -l scripts/check-keymaps.lua`.
-- Exits 1 on drift, 0 when in sync.

local function read(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local s = f:read("*a")
  f:close()
  return s
end

local function walk(dir, out)
  local p = io.popen(("find %q -type f -name '*.lua'"):format(dir))
  if not p then return out end
  for line in p:lines() do table.insert(out, line) end
  p:close()
  return out
end

local root = vim.fn.getcwd()
local lua_files = {}
walk(root .. "/lua/plugins", lua_files)
walk(root .. "/lua/config", lua_files)

-- Extract "<leader>…" string literals from lua sources.
local code = {}
for _, file in ipairs(lua_files) do
  local src = read(file)
  if src then
    for key in src:gmatch('"(<[Ll]eader>[^"]-)"') do
      code[key] = code[key] or file
    end
  end
end

-- Drop which-key group/proxy declarations: `{ "<leader>x", group = "…" }` and
-- `{ "<leader>x", … proxy = "…" }`. These are labels, not user-facing keymaps.
for _, file in ipairs(lua_files) do
  local src = read(file) or ""
  for key in src:gmatch('{%s*"(<[Ll]eader>[^"]-)"[^}]-group%s*=') do
    code[key] = nil
  end
  for key in src:gmatch('{%s*"(<[Ll]eader>[^"]-)"[^}]-proxy%s*=') do
    code[key] = nil
  end
  -- Stub `keys = { "<leader>x", "" }` entries (just to make which-key show a group).
  for key in src:gmatch('{%s*"(<[Ll]eader>[^"]-)"%s*,%s*""%s*[,}]') do
    code[key] = nil
  end
end

-- Extract `<leader>…` backtick-quoted keys from docs/keymaps.md.
-- Supports single-backtick and double-backtick code spans (`` <leader>` `` for keys
-- containing a literal backtick). Markdown escapes `\|` for literal pipe; normalize.
local docs = {}
local doc_src = read(root .. "/docs/keymaps.md") or ""
for key in doc_src:gmatch("``%s*(<[Ll]eader>.-)%s*``") do
  docs[key:gsub("\\|", "|")] = true
end
for key in doc_src:gmatch("`(<[Ll]eader>[^`]-)`") do
  docs[key:gsub("\\|", "|")] = true
end

local function diff(a, b)
  local missing = {}
  for k in pairs(a) do
    if not b[k] then table.insert(missing, k) end
  end
  table.sort(missing)
  return missing
end

local in_code_not_docs = diff(code, docs)
local in_docs_not_code = diff(docs, code)

local function print_list(label, items)
  if #items == 0 then return end
  io.stderr:write(("\n%s (%d):\n"):format(label, #items))
  for _, k in ipairs(items) do
    local origin = code[k] and (" — " .. code[k]:gsub(root .. "/", "")) or ""
    io.stderr:write(("  %s%s\n"):format(k, origin))
  end
end

-- Strict on code→docs (new keymap forgotten in docs is the drift we care about).
-- Informational on docs→code (docs may document plugin defaults / proxied subkeys).
print_list("DRIFT: in code, missing from docs/keymaps.md", in_code_not_docs)
print_list("Note: in docs/keymaps.md, no matching keymap in code (plugin defaults / proxied subkeys are OK here)", in_docs_not_code)

if #in_code_not_docs == 0 then
  local n = 0; for _ in pairs(code) do n = n + 1 end
  print(("keymaps in sync (%d <leader> bindings)"):format(n))
  vim.cmd("qa")
else
  vim.cmd("cq")
end
