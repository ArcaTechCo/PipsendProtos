# 🔧 Desarrollo Local con Replace

Esta guía te ayuda a probar cambios en PipsendProtos **localmente** antes de publicarlos.

---

## 🎯 ¿Cuándo usar Replace?

Usa `replace` cuando:
- ✅ Estás desarrollando nuevos endpoints en PipsendProtos
- ✅ Quieres probar cambios sin crear un tag
- ✅ Necesitas iterar rápidamente entre PipsendProtos y servicios

**NO uses replace en:**
- ❌ Producción
- ❌ Commits finales (siempre usa versiones con tag)

---

## 📝 Paso a Paso

### 1. Editar Proto en PipsendProtos

```bash
cd /Users/carlosaroca/Desktop/Development/PipsendPlatform/PipsendProtos

# Editar el proto
vim proto/marketdata/v1/marketdata.proto

# Generar código
./scripts/generate.sh
```

### 2. Configurar Replace en el Servicio

En el servicio que quieres probar (ej: PipsendMarketData):

```bash
cd /Users/carlosaroca/Desktop/Development/PipsendPlatform/PipsendMarketData

# Agregar replace al go.mod
go mod edit -replace=github.com/ArcaTechCo/PipsendProtos=/Users/carlosaroca/Desktop/Development/PipsendPlatform/PipsendProtos

# Actualizar dependencias
go mod tidy
```

**Resultado en `go.mod`:**
```go
module github.com/ArcaTechCo/PipsendMarketData

go 1.25

require (
    github.com/ArcaTechCo/PipsendProtos v0.1.4
    // ... otras dependencias
)

replace github.com/ArcaTechCo/PipsendProtos => /Users/carlosaroca/Desktop/Development/PipsendPlatform/PipsendProtos
```

### 3. Implementar en el Servicio

Ahora puedes usar los nuevos tipos/RPCs:

```go
import pb "github.com/ArcaTechCo/PipsendProtos/gen/go/marketdata/v1"

func (s *MarketDataServer) GetProvider(ctx context.Context, req *pb.GetProviderRequest) (*pb.GetProviderResponse, error) {
    // Tu implementación aquí
}
```

### 4. Probar

```bash
# Compilar
go build ./...

# Ejecutar tests
go test ./...

# Ejecutar servidor
docker-compose up
```

### 5. Iterar

Si necesitas cambiar el proto:

```bash
# 1. Editar proto en PipsendProtos
cd /Users/carlosaroca/Desktop/Development/PipsendPlatform/PipsendProtos
vim proto/marketdata/v1/marketdata.proto

# 2. Regenerar
./scripts/generate.sh

# 3. Volver al servicio y recompilar
cd /Users/carlosaroca/Desktop/Development/PipsendPlatform/PipsendMarketData
go build ./...
```

**No necesitas** ejecutar `go mod tidy` cada vez, el `replace` ya está configurado.

---

## ✅ Validar que Replace Funciona

### Verificar go.mod

```bash
cat go.mod | grep replace
# Debe mostrar:
# replace github.com/ArcaTechCo/PipsendProtos => /Users/carlosaroca/Desktop/Development/PipsendPlatform/PipsendProtos
```

### Verificar que usa la versión local

```bash
go list -m github.com/ArcaTechCo/PipsendProtos
# Debe mostrar:
# github.com/ArcaTechCo/PipsendProtos v0.1.4 => /Users/carlosaroca/Desktop/Development/PipsendPlatform/PipsendProtos
```

### Probar compilación

```bash
go build ./internal/grpc/...
# Si compila sin errores, el replace funciona correctamente
```

---

## 🚀 Publicar Cambios (Cuando estés listo)

### 1. Remover Replace del Servicio

```bash
cd /Users/carlosaroca/Desktop/Development/PipsendPlatform/PipsendMarketData

# Remover replace
go mod edit -dropreplace=github.com/ArcaTechCo/PipsendProtos

# Verificar
cat go.mod | grep replace
# No debe mostrar nada de PipsendProtos
```

### 2. Commitear y Publicar PipsendProtos

```bash
cd /Users/carlosaroca/Desktop/Development/PipsendPlatform/PipsendProtos

# Commitear
git add .
git commit -m "feat(marketdata): Add Provider gRPC endpoints"

# Crear tag
git tag v0.1.5

# Push
git push origin main
git push origin v0.1.5
```

### 3. Actualizar Servicio con Versión Real

```bash
cd /Users/carlosaroca/Desktop/Development/PipsendPlatform/PipsendMarketData

# Actualizar a versión con tag
go get github.com/ArcaTechCo/PipsendProtos@v0.1.5
go mod tidy

# Verificar que ya no hay replace
cat go.mod | grep replace
# No debe mostrar PipsendProtos
```

---

## 🔍 Troubleshooting

### Error: "replace directive not found"

**Causa:** Ya removiste el replace o nunca lo agregaste.

**Solución:**
```bash
go mod edit -replace=github.com/ArcaTechCo/PipsendProtos=/Users/carlosaroca/Desktop/Development/PipsendPlatform/PipsendProtos
```

### Error: "module not found"

**Causa:** La ruta del replace es incorrecta.

**Solución:** Verifica que la ruta existe:
```bash
ls /Users/carlosaroca/Desktop/Development/PipsendPlatform/PipsendProtos/go.mod
# Debe existir
```

### Error: "undefined: pb.Provider"

**Causa:** No regeneraste el código después de editar el proto.

**Solución:**
```bash
cd /Users/carlosaroca/Desktop/Development/PipsendPlatform/PipsendProtos
./scripts/generate.sh
```

### Los cambios no se reflejan

**Causa:** El código generado está cacheado.

**Solución:**
```bash
# En PipsendMarketData
go clean -cache
go build ./...
```

---

## 📊 Workflow Completo de Desarrollo

```bash
# ========== FASE 1: DESARROLLO LOCAL ==========

# 1. Editar proto
cd PipsendProtos
vim proto/marketdata/v1/marketdata.proto

# 2. Generar código
./scripts/generate.sh

# 3. Configurar replace en servicio
cd ../PipsendMarketData
go mod edit -replace=github.com/ArcaTechCo/PipsendProtos=../PipsendProtos
go mod tidy

# 4. Implementar en servicio
vim internal/grpc/server.go

# 5. Probar
go build ./...
docker-compose up

# 6. Iterar (repetir pasos 1-5 hasta que funcione)

# ========== FASE 2: PUBLICACIÓN ==========

# 7. Remover replace
go mod edit -dropreplace=github.com/ArcaTechCo/PipsendProtos

# 8. Publicar PipsendProtos
cd ../PipsendProtos
git add .
git commit -m "feat(marketdata): Add Provider endpoints"
git tag v0.1.5
git push origin main --tags

# 9. Actualizar servicio con versión real
cd ../PipsendMarketData
go get github.com/ArcaTechCo/PipsendProtos@v0.1.5
go mod tidy

# 10. Commitear servicio
git add .
git commit -m "feat: Implement Provider gRPC endpoints"
git push origin main
```

---

## 💡 Tips

1. **Siempre usa rutas absolutas** en el replace para evitar problemas
2. **No commitees el replace** en el servicio
3. **Regenera el código** cada vez que edites el proto
4. **Verifica el go.mod** antes de commitear

---

**Última actualización:** Diciembre 26, 2025
