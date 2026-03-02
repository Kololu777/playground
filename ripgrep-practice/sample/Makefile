.PHONY: build test clean lint fmt

build:
	npm run build

test:
	npm run test

clean:
	rm -rf build/ dist/ node_modules/.cache

lint:
	npm run lint

fmt:
	npm run format

dev:
	npm run dev

docker-build:
	docker build -t ripgrep-practice .

docker-run:
	docker run -p 3000:3000 ripgrep-practice
