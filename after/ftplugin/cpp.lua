local opts = { noremap = true, silent = true}
function executeCurrentFile()
	local locationWithDirectory = vim.fn.expand('%:p')
	local nameOfFileWithoutExtension = vim.fn.expand('%:p:r')
	local nameOfFileWithExtension = nameOfFileWithoutExtension .. '.' .. vim.fn.expand('%:e')
	local directoryContainingFile = vim.fn.expand('%:p:h')
    -- local directoryContainingFile = vim.fn.expand('%')
	local bringUpTheTerminalAndExecute = ':sp <cr><C-w>j:terminal <cr><C-w>10-i'


   -- return  ":w<cr>".. bringUpTheTerminalAndExecute .. 'cd "' .. directoryContainingFile .. '" ; if ($?) { g++ ' .. nameOfFileWithExtension .. ' -o ' .. nameOfFileWithoutExtension .. ' } ; if ($?) { ' .. nameOfFileWithoutExtension .. ' }<cr>'
   return ":w<cr>" .. bringUpTheTerminalAndExecute .. " make \"" .. nameOfFileWithoutExtension .. "\"<cr> " .. nameOfFileWithoutExtension .. ".exe<cr>"

end

vim.api.nvim_buf_set_keymap(0, 'n', "<leader>e", executeCurrentFile(), opts)
-- vim.api.nvim_set_keymap('n', "<leader>e", executeCurrentFile(), opts)


