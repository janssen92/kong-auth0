#!/bin/bash
set -e

lua -lluacov tests/test_utils.lua -o TAP --failure
lua -lluacov tests/test_handler_mocking_openidc.lua -o TAP --failure
lua -lluacov tests/test_introspect.lua -o TAP --failure
lua -lluacov tests/test_utils_bearer_access_token.lua -o TAP --failure

