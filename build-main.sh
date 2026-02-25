#!/bin/bash
set -euo pipefail

declare -A VERSIONS=(
    [overall]=main
    [lua-atmos/f-streams]=main
    [lua-atmos/atmos]=main
    [lua-atmos/env-js]=main
    [atmos-lang/atmos]=main
)

LUA_ATMOS_MODULES=(
    "streams         lua-atmos/f-streams  ${VERSIONS[lua-atmos/f-streams]}  streams/init.lua"
    "atmos           lua-atmos/atmos      ${VERSIONS[lua-atmos/atmos]}  atmos/init.lua"
    "atmos.util      lua-atmos/atmos      ${VERSIONS[lua-atmos/atmos]}  atmos/util.lua"
    "atmos.run       lua-atmos/atmos      ${VERSIONS[lua-atmos/atmos]}  atmos/run.lua"
    "atmos.streams   lua-atmos/atmos      ${VERSIONS[lua-atmos/atmos]}  atmos/streams.lua"
    "atmos.x         lua-atmos/atmos      ${VERSIONS[lua-atmos/atmos]}  atmos/x.lua"
    "atmos.env.js    lua-atmos/env-js     ${VERSIONS[lua-atmos/env-js]}  init.lua"
)

ATMOS_LANG_MODULES=(
    "atmos.lang.global   atmos-lang/atmos  ${VERSIONS[atmos-lang/atmos]}  src/global.lua"
    "atmos.lang.aux      atmos-lang/atmos  ${VERSIONS[atmos-lang/atmos]}  src/aux.lua"
    "atmos.lang.lexer    atmos-lang/atmos  ${VERSIONS[atmos-lang/atmos]}  src/lexer.lua"
    "atmos.lang.parser   atmos-lang/atmos  ${VERSIONS[atmos-lang/atmos]}  src/parser.lua"
    "atmos.lang.prim     atmos-lang/atmos  ${VERSIONS[atmos-lang/atmos]}  src/prim.lua"
    "atmos.lang.coder    atmos-lang/atmos  ${VERSIONS[atmos-lang/atmos]}  src/coder.lua"
    "atmos.lang.tosource atmos-lang/atmos  ${VERSIONS[atmos-lang/atmos]}  src/tosource.lua"
    "atmos.lang.exec     atmos-lang/atmos  ${VERSIONS[atmos-lang/atmos]}  src/exec.lua"
    "atmos.lang.run      atmos-lang/atmos  ${VERSIONS[atmos-lang/atmos]}  src/run.lua"
)

source "$(dirname "$0")/build.sh"
