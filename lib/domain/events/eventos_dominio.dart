/// Eventos de dominio del sistema.
///
/// Los módulos funcionales (Comunicación, Rutinas, Mis Logros) se comunican
/// **exclusivamente** a través de eventos publicados en un bus interno; un módulo nunca
/// invoca directamente métodos internos de otro.
///
/// En la HU1 este archivo está intencionalmente vacío: Comunicación es el primer módulo
/// y todavía no emite ni consume eventos. Aquí se declararán, entre otros, los eventos
/// que el módulo de Comunicación publique cuando el niño seleccione o reproduzca un
/// pictograma, y que el motor de evaluación de objetivos (`ObjectiveEvaluator`) y el
/// módulo Mis Logros consumirán.
library;
