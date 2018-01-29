#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

mongo $1 --eval "db.test.insert({name:'db creation'})"
