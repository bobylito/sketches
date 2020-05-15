all: clean data/out.frag
	processing-java --sketch="${shell pwd}" --run

clean:
	rm -f data/out.frag

data/out.frag: data/shader.frag data/shader.vert
	npx glslify data/shader.frag -o data/out.frag
