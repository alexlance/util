#!/bin/bash

set -eo pipefail

p="$(apg -n 1 -m 30 -a1 -x 50 -MSNCL -E \\\$/{}\|[]*#~\'\"\`\;\-\^\(\)\!\<\>\=)"

aws iam update-login-profile --user-name alex.lance --password "${p}" || (echo "nope: ${p}" && exit 1)

export username="alex.lance"
export password="${p}"
export private="0"
export keywords="lexeraws https://lexer.signin.aws.amazon.com/console"
paw -a
