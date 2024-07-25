#!/bin/bash

set -ex

mkdir -p \
	/usr/lib64/dri \
	/usr/share/vulkan/icd.d/ \
	/usr/share/glvnd/egl_vendor.d/

if [[ -e /usr/local/share/glvnd/egl_vendor.d/50_mesa.json ]]; then
	mv /usr{/local,}/share/glvnd/egl_vendor.d/50_mesa.json
fi

if [[ -e /usr/local/share/vulkan/icd.d/intel_icd.x86_64.json ]]; then
	mv /usr{/local,}/share/vulkan/icd.d/intel_icd.x86_64.json
fi

sed -i -e 's:usr/lib:usr/local/lib:' /usr/share/vulkan/icd.d/intel_icd.x86_64.json
ln -sf /usr{/local,}/lib64/dri/iris_dri.so
