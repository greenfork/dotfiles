#!/bin/sh

# ACPI utility should be installed

acpi | awk -F, '{ print substr($2, 2) }'
