SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

(
    source "$SCRIPT_DIR/install/init.sh"
    check
)

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
    source "$SCRIPT_DIR/install/tilling/setup.sh"
    check
)

# Function to check packages in a given packages.txt file
check_packages() {
    local file="$1"
    local manager="${2:-pacman}"
    local missing_packages=()
    while IFS= read -r package; do
        # Skip comments and empty lines
        [[ "$package" =~ ^#.*$ || -z "$package" ]] && continue
        if ! $manager -Qi "$package" &>/dev/null; then
            missing_packages+=("$package")
        fi
    done < "$file"

    if [ ${#missing_packages[@]} -ne 0 ]; then
        # Display missing packages as a comma-separated list
        # Keep only the folder name of the $file path
        file="${file#$SCRIPT_DIR/install/}"
        file="${file%%/*}"
        show_error "Missing packages from $file:" "$(IFS=,; echo "${missing_packages[*]}")"
    else
        show_success "All packages from $file are installed"
    fi
}

# Loop over packages.txt files and check them
for pkg_file in "$SCRIPT_DIR/install/"*/packages.txt; do
    [ -f "$pkg_file" ] && check_packages "$pkg_file" "pacman"
done

for pkg_file in "$SCRIPT_DIR/install/"*/packages.aur.txt; do
    [ -f "$pkg_file" ] && check_packages "$pkg_file" "yay"
done