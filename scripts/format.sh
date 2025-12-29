#!/bin/bash

# Script para formatear archivos proto usando Docker
# Uso: ./scripts/format.sh

set -e

echo "✨ Formateando archivos proto..."

docker run --rm \
    -v "$(pwd):/workspace" \
    -w /workspace \
    bufbuild/buf:latest \
    format -w

echo "✅ Archivos formateados exitosamente"
