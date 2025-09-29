SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for script in "$SCRIPT_DIR/install/system/"*.sh; do 
(
    source "$script"
    check
)
done

for script in "$SCRIPT_DIR/install/apps/"*.sh; do
(
    source "$script"
    check
)
done

for script in "$SCRIPT_DIR/install/desktop/"*.sh; do
(
    source "$script"
    check
)
done

for script in "$SCRIPT_DIR/install/config/"*.sh; do
(
    source "$script"
    check
)
done

(
    source "$SCRIPT_DIR/install/hyprland/setup.sh"
    check
)