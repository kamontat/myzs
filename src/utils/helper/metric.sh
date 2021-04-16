# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

export __MYZS__DATADIR="${MYZS_DATADIR:-/tmp/myzs/data}"
export MYZS_MODULE_METRICPATH="$__MYZS__DATADIR/modules.csv"
export MYZS_PLUGIN_METRICPATH="$__MYZS__DATADIR/plugins.csv"

_myzs:private:metric:initial() {
  # update cache directory if not exist
  if _myzs:internal:checker:string-exist "$__MYZS__DATADIR" && ! _myzs:internal:checker:folder-exist "$__MYZS__DATADIR"; then
    mkdir "$__MYZS__DATADIR"
  fi
}

_myzs:internal:metric:log-module() {
  if _myzs:internal:setting:is-enabled "metrics"; then
    local data_file="${MYZS_MODULE_METRICPATH}"
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

    _myzs:internal:module:loaded-list _myzs:private:metric:counter

    echo "${__MYZS__FINISH_TIME},${passed},${failed},${skipped},${unknown},${total},${PROGRESS_LOADTIME_MS}" >>"$data_file"
  fi
}

_myzs:internal:metric:log-plugin() {
  if _myzs:internal:setting:is-enabled "metrics"; then
    local data_file="${MYZS_PLUGIN_METRICPATH}"
    if ! _myzs:internal:checker:file-exist "$data_file"; then
      echo "plugin action,plugin name,plugin version,plugin status1,plugin status2,plugin loadtime" >"$data_file"
    fi

    local plugin_start_time="$1"
    local plugin_action="$2"
    local plugin_name="$3"
    local plugin_version="$4"
    local plugin_step1_status="$5" # update repository step
    local plugin_step2_status="$6" # initial myzs.init file step

    local plugin_finish_time plugin_load_time
    plugin_finish_time="$(_myzs:internal:timestamp-millisecond)"

    export __MYZS__CURRENT_PLUGIN_KEY
    __MYZS__CURRENT_PLUGIN_KEY="$(_myzs:internal:plugin:name-serialize "${__MYZS__CURRENT_PLUGIN_TYPE}" "${__MYZS__CURRENT_PLUGIN_NAME}")"

    plugin_load_time="$((plugin_finish_time - plugin_start_time))"

    echo "${plugin_action},${plugin_name},${plugin_version},${plugin_step1_status},${plugin_step2_status},${plugin_load_time}" >>"$data_file"
  fi
}

_myzs:private:metric:initial
