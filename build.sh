#!/usr/bin/env bash

case "$USER" in
  ctrl_o)    OWL=/home/krzysckh/bin/ol ;;
  william)   OWL=~/Programming/owl-real/result/bin/ol ;;
  *)         OWL=ol ;;
esac
$OWL main.scm -x c | gcc -x c -o main -
