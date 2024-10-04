AWS_TMUX_BINARY="${AWS_TMUX_BINARY:-aws}"

command_exists() {
  local command="$1"
  command -v "$command" &>/dev/null
}

get_tmux_option() {
  local option="$1"
  local default_value="$2"
  local option_value="$(tmux show-option -gqv "$option")"
  if [ -z "$option_value" ]; then
    echo "$default_value"
  else
    echo "$option_value"
  fi
}

# ${all_interpolated/${aws_interpolation[$i]}/${aws_commands[$i]}}

simple_aws_tmux() {
  local LOGIN_STATUS

  # Check if AWS CLI is available
  if command_exists aws; then
      # Execute AWS STS Get Caller Identity
      caller_identity=$(aws sts get-caller-identity 2>&1)
      
      # Check if the command was successful
      if [ $? -eq 0 ]; then
          # Set LOGIN_STATUS to "logged_in"
          LOGIN_STATUS="#[fg=colour120 bold]⨀#[fg=default default]"
      else
          # Set LOGIN_STATUS to "logged_out"
          LOGIN_STATUS="#[fg=colour210 bold]◯#[fg=default default]"
      fi
  else
      # If AWS CLI is not available, set LOGIN_STATUS to "logged_out"
      LOGIN_STATUS="#[fg=colour210 bold]◯#[fg=default default]"
  fi

  echo "${LOGIN_STATUS}"
}