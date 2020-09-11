# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

export __MYZS__DATADIR="${MYZS_DATADIR:-/tmp/myzs/data}"
export MYZS_METRICPATH="$__MYZS__DATADIR/metric.csv"

_myzs:private:metric:initial() {
  # update cache directory if not exist
  if _myzs:internal:checker:string-exist "$__MYZS__DATADIR" && ! _myzs:internal:checker:folder-exist "$__MYZS__DATADIR"; then
    mkdir "$__MYZS__DATADIR"
  fi
}

_myzs:internal:metric:saved() {
  local data_file="${MYZS_METRICPATH}"
  if ! _myzs:internal:checker:file-exist "$data_file"; then
    echo "date time,passed modules,failed modules,skipped modules,unknown modules,total modules,load time" >"$data_file"
  fi

  local passed=0 failed=0 skipped=0 unknown=0 total=0

  _myzs:private:metric:counter() {
    local module_status="$3"
    total="$5"
    if [[ "$module_status" == "pass" ]]; then
      passed=$((passed + 1))
    elif [[ "$module_status" == "fail" ]]; then
      failed=$((failed + 1))
    elif [[ "$module_status" == "skip" ]]; then
      skipped=$((skipped + 1))
    else
      unknown=$((unknown + 1))
    fi
  }

  _myzs:internal:module:loop _myzs:private:metric:counter

  echo "${__MYZS__FINISH_TIME},${passed},${failed},${skipped},${unknown},${total},${PROGRESS_LOADTIME_MS}" >>"$data_file"
}

_myzs:private:metric:initial
