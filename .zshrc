# Homebrew variables
eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_NO_ANALYTICS=1

# Aliases
alias c=clear
alias lg=lazygit

autoload -Uz compinit
compinit

# Enable Vim mode
set -o vi

# ZSH plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Prompts to select the nvim config
nv() {
  select config in nvim nvim-lazy nvim-kickstart nvim-ios
  do
    NVIM_APPNAME=$config nvim $@;
    break;
  done
}

# Zoxide setup
eval "$(zoxide init zsh)"

# Oh My Posh config
eval "$(oh-my-posh init zsh --config ~/.config/omp/theme.json)"
