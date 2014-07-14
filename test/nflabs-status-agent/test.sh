#!/bin/bash
#
# Unitest [test.sh]
#

. ../../nflabs-status-agent/functions

# Really basic Tests

function test_get_memory_usage_works() {
  local res
  res=$(get_ip_address)
  assertNotNull "${res}"
  assertNotEquals "${res}" "\"mem_usage\":"
  assertNotEquals "${res}" "\"mem_usage\": "
}

function test_get_load_average_works() {
  local res
  res=$(get_load_average)
  assertNotNull "${res}"
  assertNotEquals "${res}" " "
  assertNotEquals "${res}" "\"load_1m\":00:00 up 0 mins, \"load_5m\": 0 users, \"load_15m\": load averages: , \"cpu_usage\":"
  assertNotEquals "${res}" "\"load_1m\": up mins, \"load_5m\": users, \"load_15m\": load averages: , \"cpu_usage\":"
}

function test_get_disk_usage_works() {
  local res
  res=$(get_disk_usage)
  assertNotNull "${res}"
  assertNotEquals "${res}" "[ ]"
}

function test_get_network_usage_works() {
  local res
  res=$(get_network_usage)
  assertNotNull "${res}"
  assertNotEquals "${res}" "\"net_receive\": 0, \"net_send\": 0"
  assertNotEquals "${res}" "\"net_receive\": , \"net_send\": "
}

function test_get_ip_address_works() {
  local res
  res=$(get_ip_address)
  assertNotNull "${res}"
  assertNotEquals "${res}" "[ ]"
}

## Call and Run all Tests
. ../framework/shunit2/src/shunit2
