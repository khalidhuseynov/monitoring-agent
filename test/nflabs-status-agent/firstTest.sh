#!/bin/bash
#
### firstTest.sh ###

. ../../nflabs-status-agent/functions

# Really basic Tests

function test_get_memory_usage_works() {
  assertNotNull $(get_ip_address)
  assertNotEquals $(get_ip_address) "\"mem_usage\":"
}

function test_get_load_average_works() {
  assertNotNull $(get_load_average)
  assertNotEquals $(get_ip_address) " "
}

function test_get_disk_usage_works() {
  assertNotNull $(get_disk_usage)
  assertNotEquals $(get_ip_address) "[ ]"
}

function test_get_network_usage_works() {
  assertNotNull $(get_network_usage)
  assertNotEquals $(get_ip_address) " "
}

function test_get_ip_address_works() {
  assertNotNull $(get_ip_address)
  assertNotEquals $(get_ip_address) "[ ]"
}

## Call and Run all Tests
. "../framework/shunit2/src/shunit2"
