#!/usr/bin/env bash

MISE_GITHUB_TOKEN="$(op read op://Parents/github.com/Tokens/mise)"
export MISE_GITHUB_TOKEN
POP_TO="$(op read op://Parents/Resend/username)"
export POP_TO
RESEND_API_KEY="$(op read op://Parents/Resend/API Key)"
export RESEND_API_KEY
