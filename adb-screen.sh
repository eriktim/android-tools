#!/bin/sh

adb shell screencap -p | sed 's/\r$//' > screen.png
