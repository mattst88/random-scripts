#!/bin/bash

echo Before
cat      /sys/kernel/debug/tracing/events/i915/enable
echo 1 > /sys/kernel/debug/tracing/events/i915/enable

cat      /sys/kernel/debug/tracing/instances/drm/events/i915/enable
echo 1 > /sys/kernel/debug/tracing/instances/drm/events/i915/enable

cat                 /sys/kernel/debug/tracing/buffer_size_kb
echo $((40*1024)) > /sys/kernel/debug/tracing/buffer_size_kb

cat      /sys/kernel/debug/tracing/tracing_on
echo 1 > /sys/kernel/debug/tracing/tracing_on

echo After
cat /sys/kernel/debug/tracing/events/i915/enable
cat /sys/kernel/debug/tracing/instances/drm/events/i915/enable
cat /sys/kernel/debug/tracing/buffer_size_kb
cat /sys/kernel/debug/tracing/tracing_on
