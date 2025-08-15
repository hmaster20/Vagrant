#!/usr/bin/env bash

# supports YAML files in nano
cat <<EOF | sudo tee /usr/share/nano/yaml.nanorc > /dev/null
syntax "YAML" "\.ya?ml$"
header "^(---|===)" "%YAML"

## Keys
color magenta "^\s*[\$A-Za-z0-9_-]+\:"
color brightmagenta "^\s*@[\$A-Za-z0-9_-]+\:"

## Values
color white ":\s.+$"
## Booleans
icolor brightcyan " (y|yes|n|no|true|false|on|off)$"
## Numbers
color brightred " [[:digit:]]+(\.[[:digit:]]+)?"
## Arrays
color red "\[" "\]" ":\s+[|>]" "^\s*- "
## Reserved
color green "(^| )!!(binary|bool|float|int|map|null|omap|seq|set|str) "

## Comments
color brightwhite "#.*$"

## Errors
color ,red ":\w.+$"
color ,red ":'.+$"
color ,red ":".+$"
color ,red "\s+$"

## Non closed quote
color ,red "['\"][^['\"]]*$"

## Closed quotes
color yellow "['\"].*['\"]"

## Equal sign
color brightgreen ":( |$)"
EOF
