#!/bin/bash

benchmark_name="ui.BenchmarkCUJ.motionmark"

flags=( CanvasOopRasterization Vulkan DefaultANGLEVulkan VulkanFromANGLE )
num_flags=${#flags[@]}
header=

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

	benchmarks=($(jq 'keys | .[] | select(match("Benchmark"))' "${name}-0.json"))
	if [[ -z ${header} ]]; then
		printf "%s," "${benchmarks[@]}"
		header=1
	fi
	echo -n "${name}",
	for benchmark in "${benchmarks[@]}"; do
		average=$(jq ".[${benchmark}].summary.value" "${name}"-*.json | jq -s add/length)
		echo -n "$average,"
	done
	echo
done
