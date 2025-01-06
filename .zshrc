# Homebrew variables
eval "$(/opt/homebrew/bin/brew shellenv)"

# ZSH plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Oh My Posh config
eval "$(oh-my-posh init zsh --config ~/.config/omp/theme.json)"
