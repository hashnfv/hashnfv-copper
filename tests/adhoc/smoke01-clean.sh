#!/bin/bash
# Copyright 2015-2016 AT&T Intellectual Property, Inc
#  
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#  
# http://www.apache.org/licenses/LICENSE-2.0
#  
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# What this is: Cleanup script for a basic test to validate an OPNFV install. 
#
# Status: this is a work in progress, under test. 
#
# How to use:
#   Install Congress test server per https://wiki.opnfv.org/copper/academy
#   $ source ~/git/copper/tests/adhoc/smoke01.sh
#   After test, cleanup with
#   $ source ~/git/copper/tests/adhoc/smoke01-clean.sh

wget https://git.opnfv.org/cgit/copper/plain/components/congress/install/bash/setenv.sh -O ~/setenv.sh
source ~/setenv.sh

echo "Disassociate cirros1 floating IP address"
nova floating-ip-disassociate cirros1 192.168.10.201

echo "Delete cirros1 instance"
instance=$(nova list | awk "/ cirros1 / { print \$2 }")
if [ "$instance" != "" ]; then nova delete $instance; fi

echo "Delete cirros2 instance"
instance=$(nova list | awk "/ cirros2 / { print \$2 }")
if  [ "$instance" != "" ]; then nova delete $instance; fi

echo "Delete 'ssh_ingress' security group"
sg=$(neutron security-group-list | awk "/ ssh_ingress / { print \$2 }")
neutron security-group-delete $sg

echo "Get 'router' ID"
router=$(neutron router-list | awk "/ public_router / { print \$2 }")

echo "Get internal port ID with subnet 10.0.0.1 on 'public_router'"
internal_interface=$(neutron router-port-list $router | grep 10.0.0.1 | awk '{print $2}')

echo "If found, delete the port with subnet 10.0.0.1 on 'public_router'"
if [ "$internal_interface" != "" ]; then neutron router-interface-delete $router port=$internal_interface; fi

echo "Get public port ID with fixed_ip 192.168.10.2 on 'public_router'"
public_interface=$(neutron router-port-list $router | grep 192.168.10.2 | awk '{print $2}')

echo "If found, delete the port with fixed_ip 192.168.10.2 on 'public_router'"
if [ "$public_interface" != "" ]; then neutron router-interface-delete $router port=$public_interface; fi

echo "Delete the router internal interface"
neutron router-interface-delete $router $internal_interface

echo "Clear the router gateway"
neutron router-gateway-clear public_router

echo "Delete the router"
neutron router-delete public_router

echo "Delete neutron port with fixed_ip 10.0.0.1"
port=$(neutron port-list | awk "/ 10.0.0.1 / { print \$2 }")
if [ "$port" != "" ]; then neutron port-delete $port; fi

echo "Delete neutron port with fixed_ip 10.0.0.2"
port=$(neutron port-list | awk "/ 10.0.0.2 / { print \$2 }")
if [ "$port" != "" ]; then neutron port-delete $port; fi

echo "Delete internal subnet"
neutron subnet-delete internal

echo "Delete internal network"
neutron net-delete internal

echo "Delete public subnet"
neutron subnet-delete public

echo "Delete public network"
neutron net-delete public

