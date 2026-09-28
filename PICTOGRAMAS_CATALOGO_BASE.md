# Catálogo base de pictogramas

Los 24 pictogramas de `assets/pictogramas/base/` fueron descargados desde la API pública de
ARASAAC y quedan incorporados en la aplicación. **No se descarga nada en tiempo de
ejecución**: el catálogo funciona sin conexión a Internet.

## Licencia y atribución

Autor de los pictogramas: **Sergio Palao**. Origen: **ARASAAC** (<https://arasaac.org>).
Propiedad: **Gobierno de Aragón**. Distribuidos bajo licencia
**Creative Commons BY-NC-SA 4.0**.

El uso debe ser **no comercial**, la **atribución es obligatoria** y toda obra derivada debe
compartirse bajo la misma licencia. Esta atribución debe mantenerse en cualquier
distribución de ComunicaPicto.

## Contenido

Cada archivo se obtuvo de `https://static.arasaac.org/pictograms/{id}/{id}_500.png`.

### Necesidades básicas

| Texto | Archivo | ID ARASAAC |
|---|---|---|
| Agua | `agua.png` | 2248 |
| Baño | `bano.png` | 2430 |
| Dormir | `dormir.png` | 2369 |
| Ayuda | `ayuda.png` | 12252 |
| Sí | `si.png` | 5584 |
| No | `no.png` | 5526 |

### Emociones

| Texto | Archivo | ID ARASAAC |
|---|---|---|
| Feliz | `feliz.png` | 9907 |
| Triste | `triste.png` | 2606 |
| Enfadado | `enfadado.png` | 2374 |
| Asustado | `asustado.png` | 2261 |
| Cansado | `cansado.png` | 2314 |
| Tranquilo | `tranquilo.png` | 37828 |

### Comida

| Texto | Archivo | ID ARASAAC |
|---|---|---|
| Hambre | `hambre.png` | 35559 |
| Pan | `pan.png` | 2494 |
| Leche | `leche.png` | 2445 |
| Manzana | `manzana.png` | 2462 |
| Plátano | `platano.png` | 2530 |
| Arroz | `arroz.png` | 6911 |

### Actividades

| Texto | Archivo | ID ARASAAC |
|---|---|---|
| Jugar | `jugar.png` | 2439 |
| Música | `musica.png` | 11311 |
| Pintar | `pintar.png` | 2348 |
| Leer | `leer.png` | 28643 |
| Pelota | `pelota.png` | 3241 |
| Ver televisión | `television.png` | 2782 |

## Criterio de selección

Para cada término se consultó `https://api.arasaac.org/api/pictograms/es/search/{término}`,
se descartaron los resultados marcados como `violence` o `sex`, y se prefirió el pictograma
a color y concreto frente a la variante esquemática.

La excepción es el vocabulario nuclear **Sí** y **No**, donde la variante esquemática
(marca verde y aspa roja) es la convención habitual en CAA y la que efectivamente se usó.
Los 24 pictogramas fueron revisados visualmente uno a uno antes de incorporarse.

## Cómo reemplazar o ampliar el catálogo

1. Buscar el pictograma en <https://arasaac.org/pictograms/search> y anotar su ID.
2. Guardar la imagen en `assets/pictogramas/base/` con el nombre de archivo correspondiente.
3. Si se trata de un pictograma nuevo, añadirlo a `SeedCatalogoBase.catalogoBase` en
   `lib/data/database/seed_catalogo_base.dart` y actualizar este documento.
4. Desinstalar la aplicación del dispositivo antes de reinstalarla: el indicador
   `catalogoBaseInicializado` impide volver a sembrar sobre una base de datos existente.
