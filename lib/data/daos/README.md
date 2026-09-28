# `lib/data/daos/`

Data Access Objects de Drift (`@DriftAccessor`).

Vacío en la HU1: las consultas del catálogo son lo bastante simples como para vivir
directamente en los repositorios de `lib/data/repositories/`, que ya son la única capa con
acceso a `AppDatabase`.

Se extraerán DAOs cuando las consultas crezcan —por ejemplo, los `JOIN` entre rutinas,
pasos y logros— para no inflar los repositorios ni la clase de base de datos.
