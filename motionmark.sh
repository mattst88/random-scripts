#!/bin/bash

dut="dut2"
benchmark_name="ui.BenchmarkCUJ.motionmark"

flags=( CanvasOopRasterization Vulkan DefaultANGLEVulkan VulkanFromANGLE )
num_flags=${#flags[@]}
iters=3

for (( i = 0; i < 2**num_flags; i++ )); do
	enabled=""
	disabled=""
	name=""

	for (( j = 0; j < num_flags; j++ )); do
		if [[ "$(( i & (1<<j) ))" != 0 ]]; then
			enabled="${flags[$j]},${enabled}"
		else
			disabled="${flags[$j]},${disabled}"
			name+="-"
		fi
		name+="${flags[$j]},"
	done

	enabled="${enabled%,}"
	disabled="${disabled%,}"
	name="${benchmark_name}:${name%,}"

	echo Running "${name} ${iters} times"
	ssh dut2 "echo --enable-features=${enabled} --disable-features=${disabled} > /etc/chrome_dev.conf ; restart ui"

	for (( iter = 0; iter < iters; iter++ )); do
		tast run -var=cujrecorder.isLocal=true -var=cuj.isLocal=true "${dut}" "${benchmark_name}"
		cp /tmp/tast/results/latest/tests/"${benchmark_name}"/results-chart.json ~/"${name}-${iter}".json
	done
done
