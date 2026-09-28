# ComunicaPicto

Aplicación móvil Android de comunicación aumentativa y alternativa (CAA) para niños con
Trastorno del Espectro Autista (TEA) con comunicación verbal limitada. Apoya la comunicación
y la autonomía mediante pictogramas, rutinas visuales y seguimiento de logros.

Funciona **offline-first**: la totalidad de sus funciones opera sin conexión a Internet.

## Stack tecnológico

| Componente | Tecnología |
|---|---|
| Framework | Flutter 3.47 (canal estable) |
| Lenguaje | Dart 3.13 |
| Persistencia | SQLite mediante [Drift](https://drift.simonbinder.eu/) |
| UI | `package:material_ui` (Material como paquete independiente, ADR-005) |
| Arquitectura | MVVM + Clean Architecture ligera (Repository Pattern + ViewModels) |
| Identificadores | UUID v4 en todas las entidades |

## Requisitos previos

- **Flutter SDK 3.47** o superior (canal `stable`)
- **Android SDK** con `ANDROID_HOME` configurado
- **NDK 28.2.13676358**
- Dispositivo Android físico o emulador con **API 23 (Android 6.0)** o superior
- `flutter doctor` sin errores bloqueantes

## Instalación

```bash
git clone <url-del-repositorio>
cd comunicapicto
```

Instalar las dependencias:

```bash
flutter pub get
```

Generar el código de Drift (tablas, DAOs y `AppDatabase`):

```bash
dart run build_runner build
```

> Este paso es **obligatorio** antes del primer `flutter run`: los archivos `*.g.dart` no se
> versionan y sin ellos el proyecto no compila. Durante el desarrollo puede usarse
> `dart run build_runner watch` para regenerarlos automáticamente.
>
> La opción `--delete-conflicting-outputs` fue eliminada en `build_runner` 2.16 y ya no
> debe pasarse.

Ejecutar la aplicación en el dispositivo conectado:

```bash
flutter run
```

Ejecutar las pruebas:

```bash
flutter test
```

## Estructura de carpetas

```
lib/
 ├── data/
 │    ├── database/          # Tablas Drift, AppDatabase y script de seed del catálogo base
 │    ├── daos/              # Data Access Objects de Drift
 │    └── repositories/      # Implementaciones concretas de los repositorios
 ├── domain/
 │    ├── entities/          # Modelos de dominio, independientes de Drift
 │    └── events/            # Eventos de dominio para la comunicación entre módulos
 ├── presentation/
 │    └── comunicacion/
 │         ├── screens/      # Pantallas del módulo de Comunicación
 │         ├── viewmodels/   # ViewModels (estado y lógica de presentación)
 │         └── widgets/      # Widgets reutilizables del módulo
 └── services/               # Servicios de plataforma (TTS, seguridad, imágenes)
assets/
 └── pictogramas/
      └── base/              # Catálogo base de pictogramas ARASAAC incorporado en la app
```

Reglas estructurales que el proyecto respeta sin excepción:

- Las pantallas y los ViewModels **nunca** acceden directamente a Drift; siempre lo hacen a
  través de un repositorio.
- Los módulos funcionales (Comunicación, Rutinas, Mis Logros) se comunican **exclusivamente**
  mediante eventos de dominio; un módulo nunca invoca métodos internos de otro.

## Convenciones de commits

| Prefijo | Uso |
|---|---|
| `feat:` | Nueva funcionalidad |
| `fix:` | Corrección de errores |
| `docs:` | Documentación |
| `test:` | Pruebas |
| `config:` | Configuración, dependencias y herramientas |

## Convención de ramas

| Rama | Propósito |
|---|---|
| `main` | Código estable y liberable |
| `develop` | Integración de funcionalidades en curso |
| `feature/*` | Desarrollo de una historia de usuario (ej. `feature/HU1-catalogo-pictogramas`) |
| `hotfix/*` | Correcciones urgentes sobre `main` |

## Atribución de los pictogramas

Los pictogramas incluidos en el catálogo base son propiedad del **Gobierno de Aragón** y han
sido creados por **Sergio Palao** para **ARASAAC** (<https://arasaac.org>), que los distribuye
bajo licencia **Creative Commons BY-NC-SA 4.0**.

Ello implica que su uso debe ser **no comercial**, que la **atribución es obligatoria** y que
cualquier obra derivada debe compartirse bajo la misma licencia. Esta atribución debe
mantenerse en toda distribución de la aplicación.

## Estado del proyecto

En **desarrollo activo**. Actualmente en el Sprint de Emergencia, con la **HU1 (carga
automática del catálogo base de pictogramas y categorías predeterminadas)** en curso.

Los módulos de Rutinas y Mis Logros, el modo de administración protegida y la síntesis de voz
(TTS) aún no están implementados.

## Autoría

- **Autor:** Matías Valencia Fuentes
- **Profesora guía:** Giannina Costa

Proyecto de título, Ingeniería en Computación e Informática, **Universidad Andrés Bello**.
