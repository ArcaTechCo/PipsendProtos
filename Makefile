.PHONY: generate clean lint format install-tools check

install-tools:
	@echo "Installing buf..."
	go install github.com/bufbuild/buf/cmd/buf@latest

generate:
	@echo "Generating Go code from proto files..."
	buf generate

clean:
	@echo "Cleaning generated code..."
	rm -rf gen/go/*

lint:
	@echo "Linting proto files..."
	buf lint

format:
	@echo "Formatting proto files..."
	buf format -w

breaking:
	@echo "Checking for breaking changes..."
	buf breaking --against '.git#branch=main'

check: lint
	@echo "✓ Proto files are valid"
	@test -d gen/go/accounts/v1 || (echo "✗ Generated code missing for accounts" && exit 1)
	@test -d gen/go/marketdata/v1 || (echo "✗ Generated code missing for marketdata" && exit 1)
	@test -d gen/go/tradingmetrics/v1 || (echo "✗ Generated code missing for tradingmetrics" && exit 1)
	@echo "✓ All generated code exists"
