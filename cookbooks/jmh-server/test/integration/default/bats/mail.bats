#!/usr/bin/env bats

@test "postfix binary is found in PATH" {
  run which postfix
  [ "$status" -eq 0 ]
}