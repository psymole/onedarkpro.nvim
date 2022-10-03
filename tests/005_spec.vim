if !isdirectory('plenary.nvim')
  !git clone https://github.com/nvim-lua/plenary.nvim.git plenary.nvim
  !git -C plenary.nvim reset --hard 1338bbe8ec6503ca1517059c52364ebf95951458
endif

set runtimepath+=plenary.nvim,.
set noswapfile
set noundofile

lua << EOF
local onedarkpro = require("onedarkpro")
onedarkpro.setup({
    plugins = {
        all = false,
        treesitter = true,
    },
    colors = {
      my_new_red = "#FF0000",
    },
    highlights = {
      OneDarkPro = { fg = "${my_new_red}" }
    },
    ft_highlights = {
      ruby = {
        Comment = { fg = "${green}", bg = "${green}" }, Function = { fg = "${green}", bg = "${green}" },
      },
      lua = {
        Comment = { fg = "${purple}", bg = "${purple}" },
        Function = { fg = "${purple}", bg = "${purple}" },
      },
    },
})
vim.cmd [[colorscheme onedarkpro]]
EOF

runtime plugin/plenary.vim
command Test5 PlenaryBustedFile tests/005_spec.lua

