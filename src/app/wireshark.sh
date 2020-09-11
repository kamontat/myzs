# shellcheck disable=SC1090,SC2148

wireshark_config="/etc/paths.d/Wireshark"
if _myzs:internal:checker:file-exist "$wireshark_config"; then
  wireshark_path="$(cat "$wireshark_config")"
  _myzs:internal:path-append "$wireshark_path"
fi

wireshark_manpage="/etc/manpaths.d/Wireshark"
if _myzs:internal:checker:file-exist "$wireshark_manpage"; then
  wireshark_manpath="$(cat "$wireshark_manpage")"
  _myzs:internal:manpath-push "$wireshark_manpath"
fi

unset wireshark_config wireshark_manpage
unset wireshark_path wireshark_manpath
