-- Better quickfix: preview pane, multi-select, fuzzy filter inside qf window
return {
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      auto_enable = true,
      preview = {
        auto_preview = true,
        win_height = 12,
        win_vheight = 12,
      },
      func_map = {
        vsplit   = "v",
        split    = "s",
        tab      = "t",
        prevfile = "K",
        nextfile = "J",
        ptogglemode = "p",
      },
    },
  },
}
