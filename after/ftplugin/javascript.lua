local opts = { noremap = true, silent = true}
function executeCurrentFile()
	local locationWithDirectory = vim.fn.expand('%:p')
	local nameOfFileWithoutExtension = vim.fn.expand('%:r')
	local nameOfFileWithExtension = nameOfFileWithoutExtension .. '.' .. vim.fn.expand('%:e')
	local directoryContainingFile = vim.fn.expand('%:p:h')
	local bringUpTheTerminalAndExecute = ':sp <cr><C-w>j:terminal <cr><C-w>10-i'

   return ":w<cr>" .. bringUpTheTerminalAndExecute .. 'node ' .. locationWithDirectory .. '<cr>'
end

vim.api.nvim_buf_set_keymap(0, 'n', "<leader>e", executeCurrentFile(), opts)
