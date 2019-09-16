# shellcheck disable=SC1090,SC2148

# Install zgen
if is_command_exist "git" && ! is_folder_exist "${HOME}/.zgen"; then
  git clone "https://github.com/tarjoilija/zgen.git" "${HOME}/.zgen" &>/dev/null
fi
