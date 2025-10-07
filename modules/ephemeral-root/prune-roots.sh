argv0="prune-roots"

help() {
cat <<EOF
$argv0 - Prune non-current root filesystems.

Usage: $argv0 [options...]

Options:
  -k, --keep=n
    Keep the latest n roots.

  -b, --before=date
    Prune roots from before date.

  -y, --yes
    Delete filesystems without confirmation.

  -n, --dry-run
    List filesystems that would be deleted.

  -l, --list
    List all non-current filesystems along with their creation times.

  -h, --help
    Display this message.

If both --keep and --before are specified, a filesystem will need to
match both filters to be selected for deletion.
EOF
}

list() {
  local filesystems=("$@")
  (
    printf "AGE NAME CREATION\n"
    for i in "${!filesystems[@]}"; do
      age="$((${#filesystems[@]}-$i))"
      fs="${filesystems[$i]}"
      creation="$(date -d "@$(zfs get -Hpo value creation "$fs")")"
      printf "%d %s %s\n" "$age" "$fs" "$creation"
    done
  ) | column -tl3
}

keep=""
before=""
confirmation=""
dry=""

readarray -t filesystems < <(\
  zfs list -t filesystem -Ho name -s creation \
    | awk '/^system\/root\// && !/^system\/root\/current$/' \
)

while [ $# -gt 0 ]; do
  case "$1" in
    -k*|--keep|--keep=*)
        keep="${1/#-k/}"
        if [ -z "$keep" ] || [ "$keep" = "$1" ]; then
          keep="${1#*=}"
        fi
        if [ -z "$keep" ] || [ "$keep" = "$1" ]; then
          if [ $# -lt 2 ]; then
            printf "Error: Flag needs an argument: %s\n" "$1" >&2
            exit 1
          fi
          keep="$2"
          shift
        fi
        shift
        if [ ! "$keep" -ge 0 ]; then
          printf "Error: Invalid value for --keep: Must be an unsigned integer.\n" >&2
          exit 1
        fi
      ;;
    -b*|--before*)
        before="${1/#-b/}"
        if [ -z "$before" ] || [ "$before" = "$1" ]; then
          before="${1#*=}"
        fi
        if [ -z "$before" ] || [ "$before" = "$1" ]; then
          if [ $# -lt 2 ]; then
            printf "Error: Flag needs an argument: %s\n" "$1" >&2
            exit 1
          fi
          before="$2"
          shift
        fi
        shift
        if date -d "$before" 2>/dev/null >/dev/null; then
          before="$(date -d "$before" +%s)"
        else
          error="$(date -d "$before" 2>&1)"
          error="${error#date: }"
          printf "Error: Invalid value for --before: %s\n" "${error^}" >&2
          exit 1
        fi
      ;;
    -h*|--help*)
      help
      exit 0
      ;;
    -y|--yes)
      confirmation="Yes"
      shift
      ;;
    -n|--dry-run)
      dry=1
      shift
      ;;
    -l|--list)
      list "${filesystems[@]}"
      exit 0
      ;;
    *)
      printf "Error: Unknown argument: %s\n" "$1" >&2
      exit 1
  esac
done

delete=()
for i in "${!filesystems[@]}"; do
  fs="${filesystems[$i]}"
  creation="$(zfs get -Hpo value creation "$fs")"
  if [ ! -z "$before" ] && [ "$creation" -ge "$before" ]; then
    continue
  fi
  if [ ! -z "$keep" ] && [ $((${#filesystems[@]}-$i)) -le "$keep" ]; then
    continue
  fi
  delete+=($fs)
done

if [ ${#delete[@]} -le 0 ]; then
  printf "Nothing to do: No matching filesystems.\n" >&2
  exit 0
fi

list "${delete[@]}"

if [ ! -z "$dry" ]; then
  exit 0
fi

if [ "$confirmation" != "Yes" ]; then
  printf "\n"
  read -r -p "Type 'Yes' to confirm deletion of ${#delete[@]} volumes: " confirmation >&2
  if [ "$confirmation" != "Yes" ]; then
    printf "Abort.\n" >&2
    exit 1
  fi
fi

for i in "${!delete[@]}"; do
  fs="${filesystems[$i]}"
  elevate=""
  if [ $UID -ne 0 ]; then
    elevate="sudo"
    error=$($elevate true 2>&1)
    if [ $? -ne 0 ]; then
      error="${error#sudo: }"
      printf "Error: Could not elevate privileges: %s\n" "${error^}" >&2
      exit 1
    fi
  fi
  printf "Deleting filesystem '%s'...\n" "$fs" >&2
  error="$($elevate zfs destroy "$fs" 2>&1)"
  if [ $? -ne 0 ]; then
    printf "Error: Could not delete filesystem: %s\n" "${error^}" >&2
    exit 1
  fi
done

