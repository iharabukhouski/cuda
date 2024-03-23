# Makefiles require tabs for indentation

all: clean init program

init:
	# pwd
	clear
	mkdir -p ./build

program: /root/diffusion/src/program.cu
	/usr/local/cuda/bin/nvcc -g -G "/root/diffusion/src/program.cu" -o "/root/diffusion/build/program"

clean:
	rm -rf ./build
