# 🚀 Guía Rápida - PipsendProtos

## 📋 Tabla de Contenidos
- [Generar Código](#generar-código)
- [Agregar Nuevo Proto](#agregar-nuevo-proto)
- [Validar y Formatear](#validar-y-formatear)
- [Publicar Cambios](#publicar-cambios)
- [Troubleshooting](#troubleshooting)

---

## 🔧 Generar Código

### Opción 1: Script Rápido (Recomendado)

```bash
./scripts/generate.sh
```

### Opción 2: Docker Compose

```bash
docker-compose run --rm proto-gen
```

### Opción 3: Docker Directo

```bash
docker run --rm -v $(pwd):/workspace -w /workspace bufbuild/buf:latest generate
```

**Resultado:** Código Go generado en `gen/go/`

---

## ➕ Agregar Nuevo Proto

### Paso 1: Editar archivo proto

```bash
# Ejemplo: Agregar nuevo RPC a MarketData
vim proto/marketdata/v1/marketdata.proto
```

### Paso 2: Agregar el RPC al servicio

```protobuf
service MarketData {
  // ... RPCs existentes ...
  
  // NUEVO: Tu nuevo RPC
  rpc GetProvider(GetProviderRequest) returns (GetProviderResponse);
}
```

### Paso 3: Agregar mensajes

```protobuf
message GetProviderRequest {
  uint32 provider_id = 1;
}

message GetProviderResponse {
  Provider provider = 1;
}

message Provider {
  uint32 id = 1;
  string name = 2;
  // ... más campos
}
```

### Paso 4: Generar código

```bash
./scripts/generate.sh
```

### Paso 5: Verificar

```bash
git status
# Deberías ver cambios en:
# - proto/marketdata/v1/marketdata.proto
# - gen/go/marketdata/v1/marketdata.pb.go
# - gen/go/marketdata/v1/marketdata_grpc.pb.go
```

---

## ✅ Validar y Formatear

### Validar proto (lint)

```bash
./scripts/lint.sh
```

### Formatear proto

```bash
./scripts/format.sh
```

### Validar todo antes de commitear

```bash
./scripts/lint.sh && ./scripts/generate.sh
```

---

## 📦 Publicar Cambios

### Paso 1: Commitear cambios

```bash
git add proto/
git add gen/
git commit -m "feat(marketdata): Add GetProvider endpoint"
```

### Paso 2: Crear tag de versión

```bash
# Incrementar versión según cambios:
# - v0.1.X: Cambios menores (agregar campos opcionales)
# - v0.X.0: Cambios mayores (agregar RPCs, cambios breaking)

git tag v0.1.5
```

### Paso 3: Push

```bash
git push origin main
git push origin v0.1.5
```

### Paso 4: Actualizar en servicios

```bash
# En PipsendMarketData, PipsendAccountCore, etc.
cd /path/to/servicio
go get github.com/ArcaTechCo/PipsendProtos@v0.1.5
go mod tidy
```

---

## 🔍 Troubleshooting

### Error: "buf: command not found"

**Solución:** Usa los scripts con Docker:
```bash
./scripts/generate.sh
```

### Error: "permission denied"

**Solución:** Da permisos de ejecución:
```bash
chmod +x scripts/*.sh
```

### Error: "buf.yaml not found"

**Solución:** Ejecuta desde la raíz de PipsendProtos:
```bash
cd /path/to/PipsendProtos
./scripts/generate.sh
```

### Error: Docker no está corriendo

**Solución:** Inicia Docker Desktop o Docker daemon:
```bash
# macOS
open -a Docker

# Linux
sudo systemctl start docker
```

### Los cambios no se reflejan en el servicio

**Solución:** Verifica la versión:
```bash
# En go.mod del servicio, debe aparecer:
github.com/ArcaTechCo/PipsendProtos v0.1.5

# Si no, actualiza:
go get github.com/ArcaTechCo/PipsendProtos@v0.1.5
go mod tidy
```

---

## 📚 Ejemplos Comunes

### Agregar nuevo campo a mensaje existente

```protobuf
message Provider {
  uint32 id = 1;
  string name = 2;
  string type = 3;
  // NUEVO CAMPO (usar siguiente número disponible)
  string new_field = 4;
}
```

**⚠️ IMPORTANTE:** Nunca reutilices números de campos eliminados.

### Agregar nuevo RPC

```protobuf
service MarketData {
  // ... RPCs existentes ...
  
  // NUEVO RPC
  rpc GetProvider(GetProviderRequest) returns (GetProviderResponse);
}
```

### Agregar filtros opcionales

```protobuf
message ListProvidersRequest {
  optional string type = 1;           // Opcional
  optional string capabilities = 2;   // Opcional
  int32 page = 3;                     // Requerido (no optional)
}
```

---

## 🎯 Workflow Completo

```bash
# 1. Editar proto
vim proto/marketdata/v1/marketdata.proto

# 2. Formatear
./scripts/format.sh

# 3. Validar
./scripts/lint.sh

# 4. Generar código
./scripts/generate.sh

# 5. Verificar cambios
git diff

# 6. Commitear
git add .
git commit -m "feat(marketdata): Add Provider endpoints"

# 7. Tag y push
git tag v0.1.5
git push origin main --tags

# 8. Actualizar en servicios
cd ../PipsendMarketData
go get github.com/ArcaTechCo/PipsendProtos@v0.1.5
go mod tidy
```

---

## 📞 Ayuda

**Documentación oficial de buf:** https://buf.build/docs

**Estructura del proyecto:**
```
PipsendProtos/
├── proto/              # Archivos .proto (EDITAR AQUÍ)
│   ├── accounts/v1/
│   ├── marketdata/v1/
│   └── tradingmetrics/v1/
├── gen/go/            # Código generado (NO EDITAR)
│   ├── accounts/v1/
│   ├── marketdata/v1/
│   └── tradingmetrics/v1/
├── scripts/           # Scripts de generación
│   ├── generate.sh
│   ├── lint.sh
│   └── format.sh
├── buf.yaml           # Configuración de buf
├── buf.gen.yaml       # Configuración de generación
└── docker-compose.yml # Docker para generación
```

---

**Última actualización:** Diciembre 26, 2025  
**Versión actual:** v0.1.4 → v0.1.5 (pendiente)
