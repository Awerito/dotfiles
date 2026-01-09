-- K8s Secret Editor (base64 decode/encode)
local M = {
    decoded_buffers = {},
}

local function b64decode(str)
    local handle = io.popen("echo '" .. str .. "' | base64 -d 2>/dev/null")
    if handle then
        local result = handle:read("*a")
        handle:close()
        return result:gsub("\n$", "")
    end
    return str
end

local function b64encode(str)
    local handle = io.popen("echo -n '" .. str:gsub("'", "'\\''") .. "' | base64 -w0 2>/dev/null")
    if handle then
        local result = handle:read("*a")
        handle:close()
        return result:gsub("\n$", "")
    end
    return str
end

local function is_data_line(line)
    return line:match("^%s%s[%w_%-]+:%s*.+$") ~= nil
end

function M.decode()
    local bufnr = vim.api.nvim_get_current_buf()
    if M.decoded_buffers[bufnr] then
        vim.notify("Already decoded. Use :SecretEncode first.", vim.log.levels.WARN)
        return
    end

    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local in_data = false
    local modified = false

    for i, line in ipairs(lines) do
        if line:match("^data:%s*$") then
            in_data = true
        elseif line:match("^%S") and in_data then
            in_data = false
        elseif in_data and is_data_line(line) then
            local indent, key, value = line:match("^(%s+)([%w_%-]+):%s*(.+)$")
            if indent and key and value and value ~= "" then
                local decoded = b64decode(value)
                if decoded ~= value then
                    lines[i] = indent .. key .. ": " .. decoded
                    modified = true
                end
            end
        end
    end

    if modified then
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
        M.decoded_buffers[bufnr] = true
        vim.notify("Decoded. Run :SecretEncode before saving!", vim.log.levels.INFO)
    else
        vim.notify("No base64 values found.", vim.log.levels.WARN)
    end
end

function M.encode()
    local bufnr = vim.api.nvim_get_current_buf()
    if not M.decoded_buffers[bufnr] then
        vim.notify("Buffer not decoded.", vim.log.levels.WARN)
        return
    end

    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local in_data = false

    for i, line in ipairs(lines) do
        if line:match("^data:%s*$") then
            in_data = true
        elseif line:match("^%S") and in_data then
            in_data = false
        elseif in_data and is_data_line(line) then
            local indent, key, value = line:match("^(%s+)([%w_%-]+):%s*(.+)$")
            if indent and key and value and value ~= "" then
                lines[i] = indent .. key .. ": " .. b64encode(value)
            end
        end
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    M.decoded_buffers[bufnr] = nil
    vim.notify("Encoded. Safe to save.", vim.log.levels.INFO)
end

-- Commands
vim.api.nvim_create_user_command("SecretDecode", M.decode, { desc = "Decode K8s secret" })
vim.api.nvim_create_user_command("SecretEncode", M.encode, { desc = "Encode K8s secret" })

-- Keymaps
vim.keymap.set("n", "<leader>kd", ":SecretDecode<CR>", { desc = "[K]8s secret [D]ecode" })
vim.keymap.set("n", "<leader>ke", ":SecretEncode<CR>", { desc = "[K]8s secret [E]ncode" })

-- Warning when saving decoded secrets
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*/secrets/secret.*.yaml",
    callback = function()
        if M.decoded_buffers[vim.api.nvim_get_current_buf()] then
            vim.notify("WARNING: Saving decoded secret!", vim.log.levels.ERROR)
        end
    end,
})

return M
