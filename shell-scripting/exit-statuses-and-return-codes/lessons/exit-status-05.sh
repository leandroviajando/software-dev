#!/usr/bin/env bash

HOST="google.com"

ping -c 1 $HOST || echo "$HOST unreachable."

