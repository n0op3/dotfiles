$env.config.buffer_editor = "nvim"
$env.config.show_banner = false
$env.config.edit_mode = 'vi'

# wal
(cat ~/.cache/wal/sequences)

# Zoxide
source ~/.zoxide.nu

source ($nu.default-config-dir | path join "aliases.nu")
source ($nu.default-config-dir | path join "prompt.nu")
source ~/.cache/carapace/init.nu
