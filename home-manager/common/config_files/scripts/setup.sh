#!/bin/sh
pushd ~/
! [[ -d .password-store.git ]] && git clone git@github.com:WeissP/.password-store.git 
echo "SELECT 'CREATE DATABASE recentf' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'recentf')\gexec" | psql
