# Neovim Configuration

## Goals

- Simple
- Fast
- Reliable (no random errors when trying to rename a variable)
- Comfortable for general purpose editing
- Highly productive for my workflow at the time
- Locality of motion (e.g. docs should show up where you're already looking)

## Non-Goals

- Pretty
- Extensible (I just need it to work for me)

## Desired Features and Workflow

- Self-improvement
  - Discoverability/Reminder of motions
  - Keeping me in my terminal more (e.g. image preview)
  - Finding better terminal tools
  - Measurable statistics/progress/analytics
- Language Support
  - GoLang
  - Javascript/Typescript/HTML/CSS
  - Lua
- Direct navigation within a buffer
  - Jump to a specific position quickly (i.e. flash)
  - Quicker navigation to landmarks (start of current function, next param, etc.)
- UX
  - Draw attention to semantically significant text, not keywords
- Simpler cross-file navigation
  - showing references should preview where I'm going
- Automated edits
  - Format on save
  - Auto save?
  - Import automatically
  - snippets (or something stronger, more focused)
- Simpler buffer management
  - From telescope?
  - With harpoon + visual harpooning
  - snipe, but simpler?
- Easier to use powerful tooling
  - Better use of git integration
  - Integrating with zellij
  - Simple route to notes tool
- Better use of space
  - Fullscreen telescope, better layout
  - Centering the active buffer?
  - Use a split window when it makes sense
- Easier to sell
  - It should be easy to demonstrate the value of neovim to skeptics

## TODO

- <leader><leader> should search _everything_
- Better completion ordering
- On-screen harpoon tabs (and current, alt)
- better word jumping

Based on [kickstart.nvim](https://github.com/kdheepak/kickstart.nvim)
