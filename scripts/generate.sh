#!/bin/bash

# Script para generar código Go desde archivos proto usando Docker
# Uso: ./scripts/generate.sh

set -e

echo "🔧 Generando código Go desde archivos proto..."

# Verificar que estamos en el directorio correcto
if [ ! -f "buf.yaml" ]; then
    echo "❌ Error: buf.yaml no encontrado. Ejecuta este script desde la raíz de PipsendProtos"
    exit 1
fi

# Generar código usando Docker
docker run --rm \
    -v "$(pwd):/workspace" \
    -w /workspace \
    bufbuild/buf:latest \
    generate

echo "✅ Código generado exitosamente en gen/go/"
echo ""
echo "📦 Archivos generados:"
find gen/go -name "*.pb.go" -o -name "*_grpc.pb.go" | sort

echo ""
echo "✅ Listo! Ahora puedes:"
echo "   1. Revisar los cambios: git status"
echo "   2. Commitear: git add . && git commit -m 'feat: Update proto definitions'"
echo "   3. Crear tag: git tag v0.1.X && git push origin main --tags"
