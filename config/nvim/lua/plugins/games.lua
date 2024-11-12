return {
  {
    "alec-gibson/nvim-tetris",
    cmd = { "Tetris" },
  },
  {
    "seandewar/nvimesweeper",
    cmd = { "Nvimesweeper" },
  },
  {
    "seandewar/killersheep.nvim",
    cmd = { "KillKillKill" },
  },
  {
    "rktjmp/shenzhen-solitaire.nvim",
    cmd = { "ShenzhenSolitaireNewGame" },
  },
  {
    "eandrju/cellular-automaton.nvim",
    cmd = { "CellularAutomaton" },
  },
  {
    "jim-fx/sudoku.nvim",
    cmd = { "Sudoku" },
    config = true,
  },
  {
    "alanfortlink/blackjack.nvim",
    cmd = { "BlackJackNewGame" },
    opts = {
      card_style = "large",
      suit_style = "black",
      scores_path = "/tmp/blackjack-scores.json",
    },
  },
}
