#!/bin/bash

interval=5

function track {
	title=$(playerctl metadata title)
	artist=$(playerctl metadata artist)
	echo "$artist - $title"
}

function volume {
	echo $(pulsemixer --get-volume | awk '{ printf "Vol: %s%%", $1 }')
}


function disk {
	df_output=$(df -m / | grep / | tr -d %)
 	used_pct=$(echo $df_output | awk '{ print $5 }')
	avail_space=$(echo $df_output | awk '{ print $4/1000 }')
	total_space=$(echo $df_output | awk '{ print $2/1000 }')
	used_space=$(echo $total_space - $avail_space | bc)
	if (( $used_pct > 95 )); then
		color_fmt=$'\e[31m'
	else
		color_fmt=$'\e[0m'
	fi
	color_fmt=''

	printf "Disk: %1.1f/%1.1f GiB" $used_space $total_space
}

function gpu {
 	output=$(nvidia-settings -q GPUUtilization)
 	gpu_use=$(echo $output | sed -n 's/^.*graphics=\([0-9]*\),.*$/\1/p')

	used=$(nvidia-settings -t -q UsedDedicatedGPUMemory)
	total=$(nvidia-settings -t -q TotalDedicatedGPUMemory)
	vram_pct=$(echo "$used * 100 / $total" | bc)

	printf "GPU (VRAM): %s%% (%i%%)" $gpu_use $vram_pct
}

# function gpu {
# 	output=$(nvidia-settings -q GPUUtilization -q UsedDedicatedGPUMemory -q TotalDedicatedGPUMemory)
# 	gpu_use=$(echo $output | sed -n 's/^.*graphics=\([0-9]*\),.*$/\1/p')
#  	# vram_use=$(echo $output | sed -n 's/^.*memory=\([0-9]*\),.*$/\1/p')

#  	used=$(echo $output | sed -n "s/^.*Attribute 'UsedDedicatedGPUMemory'.*): \([0-9]*\)\..*$/\1/p")
#  	total=$(echo $output | sed -n "s/^.*Attribute 'TotalDedicatedGPUMemory'.*): \([0-9]*\)\..*$/\1/p")
# 	vram_pct=$(echo "($used * 100) / $total" | bc)

# 	printf "GPU (VRAM): %s%% (%s%%)" $gpu_use $vram_pct
# }

function cpu {
	cpu_use=$(mpstat | grep all | awk '{ printf "CPU: %s%%", $3 }')
	echo $cpu_use
}

function mem {
	mem=$(free -m | grep -m1 Mem: | awk '{ printf "Mem: %1.1f/%1.1f GiB", $3/1000, $2/1000 }')
	echo $mem
}

function get_date {
	currdate=$(date +'%Y-%m-%d %H:%M:%S')
	echo $currdate
}

function sync {
	N=$(echo "1*10^9 - $(date +%N)" | bc)
	curS=$(date +%S)
	S=$(echo "$interval - ($curS % $interval) - 1" | bc)
	to_sleep=$(printf "%d.%09d" $S $N)
	sleep $to_sleep
}

while true
do
	bar=("$(track)"
		"$(volume)"
		"$(cpu)"
		"$(gpu)"
		"$(mem)"
		"$(disk)"
		"$(get_date)"
	)
	out=""
	for ((i = 0; i < ${#bar[@]}; i++))
	do
		out+="| ${bar[$i]} "
	done
	out=${out:1}
	echo $out
	sync
done
