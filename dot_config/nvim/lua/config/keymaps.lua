-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local notes_dir = vim.fn.expand("~/work-environment/notes")

vim.keymap.set("n", "<leader>zn", function()
  require("telescope.builtin").find_files({
    prompt_title = "Notes",
    cwd = notes_dir,
  })
end, { desc = "Browse notes" })

vim.keymap.set("n", "<leader>zg", function()
  require("telescope.builtin").live_grep({
    prompt_title = "Search in notes",
    cwd = notes_dir,
  })
end, { desc = "Grep in notes" })

-- 3. <leader>zz — создать новую заметку с любым именем
vim.keymap.set("n", "<leader>zz", function()
  vim.ui.input({
    prompt = "New note name (without .md): ",
    completion = "file",
    default = os.date("%Y-%m-%d-"),  -- удобно, если хочешь датированные заметки
  }, function(name)
    if not name or name == "" then return end

    -- Автоматически добавляем .md, если пользователь забыл
    if not name:match("%.md$") then
      name = name .. ".md"
    end

    local full_path = notes_dir .. "/" .. name

    -- Создаём файл (и все нужные папки, если их нет)
    vim.fn.mkdir(vim.fn.fnamemodify(full_path, ":h"), "p")
    vim.cmd.edit(full_path)

    -- Опционально: вставить шаблон при создании новой заметки
    if vim.fn.getreg("%") == full_path and vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
      local template = {
        "# " .. name:gsub("%.md$", ""):gsub("[-_]", " "):gsub("^%l", string.upper),
        "",
        "Created: " .. os.date("%Y-%m-%d %H:%M"),
        "",
      }
      vim.api.nvim_buf_set_lines(0, 0, -1, false, template)
      vim.cmd("normal! G")  -- переместить курсор в конец
    end
  end)
end, { desc = "Create new note" })

-- 4. <leader>zt — быстрая сегодняшняя заметка (daily note)
vim.keymap.set("n", "<leader>zt", function()
  local today = os.date("%Y-%m-%d") .. ".md"
  local full_path = notes_dir .. "/daily/" .. today

  vim.fn.mkdir(notes_dir .. "/daily", "p")
  vim.cmd.edit(full_path)

  -- Если файл пустой — вставляем шаблон daily note
  if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
    local lines = {
      "# " .. os.date("%A, %d %B %Y"),
      "",
      "## Tasks",
      "",
      "## Notes",
      "",
    }
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.cmd("normal! gg")
  end
end, { desc = "Today's daily note" })

local create_component = require('user.react').create_react_component
vim.cmd([[command! ReactComponent lua require('user.react').create_react_component()]])

vim.keymap.set('n', '<leader>;c', '<Cmd>ReactComponent<CR>', { desc = 'Create React Component Structure' })

-- Если ваш nvim-snacks explorer использует файловый тип 'NvimSnacks',
-- вы можете сделать его buf-local:
-- map('n', '<leader>rc', '<Cmd>ReactComponent<CR>', { desc = 'Create React Component Structure', buffer = 0 })
