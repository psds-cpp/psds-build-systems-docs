#!/bin/sh
# build.sh — самый простой способ собрать проект calc

set -e

CC=cc
CFLAGS="-Wall -O2"

$CC $CFLAGS -c main.c -o main.o
$CC $CFLAGS -c calc.c -o calc.o
$CC main.o calc.o -o calc
