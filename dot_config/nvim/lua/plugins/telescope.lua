return {
  "nvim-telescope/telescope.nvim",
  keys = {
    {
      "<leader><leader>",
      function()
        require("telescope.builtin").oldfiles({
          cwd_only = true,
          tiebreak = "recent",
          previewer = true,
          prompt_title = "Recent Files",
        })
      end,
      desc = "Recent Files",
    },
  },
}
