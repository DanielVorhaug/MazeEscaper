
MSIZE=31
SEED=29
OPT=
.PHONY:synthesis/maze

all: mazev solve plot

mazev:
	-rm maze.txt
	iverilog -g2012 -o synthesis/mazegen_tb -c mazegen_tb.fl -DMAZE_SEED=${SEED} -DMAZE_SIZE=${MSIZE}
	vvp -n synthesis/mazegen_tb

solve:
	-rm synthesis/path.txt
	-rm synthesis/turtle.txt
	iverilog -g2012 -o synthesis/maze -c maze.fl -DMAZE_SEED=34 -DMAZE_SIZE=${MSIZE}
	vvp -n synthesis/maze

plot:
	python3 plotmaze.py ${OPT}

run:
	python3 run.py

clean:
	-rm allresults.yaml
	-rm *.vcd
	-rm *.log
	-rm *.txt
	-rm result.yaml
	-rm maze

test: mazev solve
