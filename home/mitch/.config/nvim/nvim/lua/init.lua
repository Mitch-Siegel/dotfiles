vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

require("nvim-tree").setup()

require('nightfox').setup({
    palettes = {
        all = {
            black = { base = "#000000", bright = "#000000", dim = "#000000" },
            bg1 = "#000000",
            bg0 = "#000000",
        }
    },
    })

-- require'lspconfig'.rust_analyzer.setup({
--     settings = {
--         ['rust-analyzer'] = {
--             check = {
--                 command = "clippy";
--             },
--             diagnostics = {
--                 enable = true;
--             }
--         }
--     }
-- })
-- 
-- 
-- require'cmp'.setup({
--   snippet = {
--     expand = function(args)
--          vim.fn["vsnip#anonymous"](args.body)
--     end,
--   },
--   sources =  {
--     { name = 'nvim_lsp' },
--     { name = 'vsnip' },
--     { name = 'path' },
--     { name = 'buffer' },
--   },
-- })

