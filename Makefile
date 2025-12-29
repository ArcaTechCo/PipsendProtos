.PHONY: generate clean lint format install-tools check help

help:
	@echo "📚 PipsendProtos - Comandos Disponibles"
	@echo ""
	@echo "  make generate    - Generar código Go desde protos (usa Docker)"
	@echo "  make lint        - Validar archivos proto (usa Docker)"
	@echo "  make format      - Formatear archivos proto (usa Docker)"
	@echo "  make clean       - Limpiar código generado"
	@echo "  make check       - Verificar que todo esté correcto"
	@echo ""
	@echo "💡 Tip: Usa ./scripts/generate.sh para más detalles"

install-tools:
	@echo "⚠️  No es necesario instalar buf localmente"
	@echo "✅ Usa 'make generate' que ejecuta buf en Docker"

generate:
	@echo "🔧 Generando código Go desde proto files..."
	@./scripts/generate.sh

clean:
	@echo "🧹 Limpiando código generado..."
	rm -rf gen/go/*
	@echo "✅ Código generado eliminado"

lint:
	@echo "🔍 Validando proto files..."
	@./scripts/lint.sh

format:
	@echo "✨ Formateando proto files..."
	@./scripts/format.sh

breaking:
	@echo "Checking for breaking changes..."
	buf breaking --against '.git#branch=main'

check: lint
	@echo "✓ Proto files are valid"
	@test -d gen/go/accounts/v1 || (echo "✗ Generated code missing for accounts" && exit 1)
	@test -d gen/go/marketdata/v1 || (echo "✗ Generated code missing for marketdata" && exit 1)
	@test -d gen/go/tradingmetrics/v1 || (echo "✗ Generated code missing for tradingmetrics" && exit 1)
	@echo "✓ All generated code exists"
