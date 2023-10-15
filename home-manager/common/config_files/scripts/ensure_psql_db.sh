#!/bin/sh

echo "Checking PSQL database $1..."
echo "SELECT 'CREATE DATABASE $1' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '$1')\gexec" | /run/current-system/sw/bin/psql
