# ruff: noqa: INP001, D100, CPY001, ERA001
# The Fuck settings file
#
# The rules are defined as in the example bellow:
#
# rules = ['cd_parent', 'git_push', 'python_command', 'sudo']
#
# The default values are as follows. Change to fit your needs.
# See https://github.com/nvbn/thefuck#settings for more information.
#
# rules = [<const: All rules enabled>]
exclude_rules = []
require_confirmation = True
wait_command = 3
no_colors = False
priority = {}
debug = False
history_limit = None
alter_history = True
wait_slow_command = 15
slow_commands = ["lein", "react-native", "gradle", "./gradlew", "vagrant"]
num_close_matches = 3
repeat = False
instant_mode = False
env = {"LC_ALL": "C", "LANG": "C", "GIT_TRACE": "1"}
