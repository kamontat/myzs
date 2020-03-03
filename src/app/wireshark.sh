# shellcheck disable=SC1090,SC2148

wireshark_config="/etc/paths.d/Wireshark"
if __myzs_is_file_exist "$wireshark_config"; then
  wireshark_path="$(cat "$wireshark_config")"
  __myzs_append_path "$wireshark_path"
fi

wireshark_manpage="/etc/manpaths.d/Wireshark"
if __myzs_is_file_exist "$wireshark_manpage"; then
  wireshark_manpath="$(cat "$wireshark_manpage")"
  __myzs_manpath "$wireshark_manpath"
fi

unset wireshark_config wireshark_manpage
unset wireshark_path wireshark_manpath
