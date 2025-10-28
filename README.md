# PipsendProtos

Módulo compartido de Protocol Buffers para la plataforma Pipsend.

## Servicios Definidos

- **accounts/v1**: Gestión de cuentas y márgenes (7 RPCs)
- **marketdata/v1**: Datos de mercado en tiempo real (6 RPCs)
- **tradingmetrics/v1**: Métricas de trading (1 RPC)

## Uso

### Generar Código

```bash
make generate
```

### Limpiar Código Generado

```bash
make clean
```

### Lint y Format

```bash
make lint
make format
```

### Verificar Todo

```bash
make check
```

## Agregar Nuevo Proto

1. Crear archivo en `proto/{domain}/v1/`
2. Actualizar `go_package` option
3. Ejecutar `make generate`
4. Commitear proto + código generado

## Estructura

```
PipsendProtos/
├── proto/              # Archivos .proto fuente
│   ├── accounts/v1/
│   ├── marketdata/v1/
│   └── tradingmetrics/v1/
└── gen/go/            # Código Go generado
    ├── accounts/v1/
    ├── marketdata/v1/
    └── tradingmetrics/v1/
```
