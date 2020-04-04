#!/bin/env bash

doas mkdir /run/postgresql
doas chown postgres:postgres /run/postgresql
cd /bedrock/strata/arch/var/lib/postgres
doas -u postgres pg_ctl -D data -l logfile start
