-- todo-comments: highlight TODO/FIXME/HACK/NOTE/PERF/WARN markers in comments,
-- with jump motions and snacks.picker integration.
return {
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TodoQuickFix", "TodoLocList" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev TODO" },
      { "<leader>ft", function() Snacks.picker.todo_comments() end, desc = "TODOs (picker)" },
    },
  },
}
