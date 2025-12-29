#!/bin/bash

# Script para validar archivos proto usando Docker
# Uso: ./scripts/lint.sh

set -e

echo "🔍 Validando archivos proto..."

docker run --rm \
    -v "$(pwd):/workspace" \
    -w /workspace \
    bufbuild/buf:latest \
    lint

echo "✅ Validación completada exitosamente"
