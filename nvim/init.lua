local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local opts = {}
require("vim-options")
require("lazy").setup("plugins")

local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    require("go.format").goimports()
  end,
  group = format_sync_grp,
})

-- LSP 진행 상황 알림을 위한 테이블 초기화
local client_notifs = {}

-- 스피너 프레임 정의
local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

-- 스피너 업데이트 함수
local function update_spinner(client_id, token)
  local notif_data = client_notifs[client_id][token]
  if notif_data == nil then
    return
  end

  local new_spinner = (notif_data.spinner + 1) % #spinner_frames
  notif_data.spinner = new_spinner

  notif_data.notification = vim.notify(nil, nil, {
    hide_from_history = true,
    icon = spinner_frames[new_spinner],
    replace = notif_data.notification,
  })

  vim.defer_fn(function()
    update_spinner(client_id, token)
  end, 100)
end

-- LSP 핸들러 설정
vim.lsp.handlers["$/progress"] = function(_, result, ctx)
  local client_id = ctx.client_id

  local val = result.value

  if not val.kind then
    return
  end

  local client = vim.lsp.get_client_by_id(client_id)
  if not client then
    return
  end

  client_notifs[client_id] = client_notifs[client_id] or {}

  local notif_data = client_notifs[client_id][result.token]

  if val.kind == "begin" then
    local message = val.message or ""
    local title = val.title or ""
    local spinner = 0

    notif_data = {
      notification = vim.notify(message, "info", {
        title = title,
        icon = spinner_frames[spinner],
        timeout = false,
        hide_from_history = false,
      }),
      spinner = spinner,
    }
    client_notifs[client_id][result.token] = notif_data
    update_spinner(client_id, result.token)
  elseif val.kind == "report" and notif_data then
    notif_data.notification = vim.notify(val.message, "info", {
      replace = notif_data.notification,
      hide_from_history = false,
    })
  elseif val.kind == "end" and notif_data then
    notif_data.notification = vim.notify(val.message or "완료", "info", {
      icon = "✔",
      replace = notif_data.notification,
      timeout = 3000,
    })
    client_notifs[client_id][result.token] = nil
  end
end
