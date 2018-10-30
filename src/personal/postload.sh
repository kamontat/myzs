# shellcheck disable=SC1090,SC2148

echo
echo "Welcome $USER to new tab of terminal"
if is_command_exist "todo.sh"; then
	todo.sh listall
fi
