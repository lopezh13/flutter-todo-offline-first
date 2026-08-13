# To Do List

Aplicación móvil de gestión de tareas desarrollada con Flutter. La información se almacena localmente con ObjectBox, por lo que las tareas pueden consultarse y modificarse sin conexión a Internet.

## Funcionalidades

- Inicio y cierre de sesión local.
- Listado reactivo de tareas.
- Creación y edición de tareas.
- Eliminación con confirmación.
- Cambio de estado entre pendiente y completada.
- Filtros por estado.
- Prioridades baja, media y alta.
- Fecha de creación y modificación.
- Persistencia local offline.
- Estados de carga, vacío y error.
- Feedback después de las operaciones principales.
- Splash screen, ícono y tema visual personalizados.

## Credenciales de demostración

```text
Usuario: Admin
Contraseña: Admin
```

Estas credenciales están almacenadas localmente y se utilizan únicamente para demostrar el flujo de acceso. No representan un mecanismo de autenticación seguro para producción.

## Tecnologías

- Flutter y Dart.
- GetX para gestión de estado, navegación e inyección de dependencias.
- ObjectBox para persistencia local y consultas reactivas.
- `intl` para presentación de fechas.
- `flutter_launcher_icons` y `flutter_native_splash` para recursos nativos.
- `flutter_test` para pruebas automatizadas.

## Arquitectura

El proyecto utiliza una separación por funcionalidad con responsabilidades inspiradas en Clean Architecture, manteniendo únicamente las capas necesarias para el alcance de la prueba.

```text
lib/
├── core/
│   └── theme/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   └── presentation/
│   ├── splash/
│   │   └── presentation/
│   └── tasks/
│       ├── data/
│       │   ├── data_sources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   └── repositories/
│       └── presentation/
│           ├── controllers/
│           ├── pages/
│           └── widgets/
├── app.dart
└── main.dart
```

Flujo principal:

```text
Widget → Controller → Repository → Local data source → ObjectBox
```

La interfaz no accede directamente a ObjectBox. El repositorio abstrae el origen de los datos y permite incorporar posteriormente una fuente remota sin modificar los widgets.

## Modelo de tarea

Cada tarea contiene:

- Identificador local.
- Título obligatorio.
- Descripción opcional.
- Prioridad.
- Estado.
- Fecha de creación.
- Fecha de modificación.

ObjectBox funciona como fuente local de verdad. Las pantallas observan los cambios mediante un stream, reduciendo el riesgo de inconsistencias entre la base local y el estado mostrado.

## Ejecución

Requisitos:

- Flutter 3.44.7 o compatible.
- Dart 3.12.2 o compatible.
- Android Studio o Xcode según la plataforma utilizada.

Instalar dependencias:

```bash
flutter pub get
```

Generar el código de ObjectBox si se modifica su entidad:

```bash
dart run build_runner build
```

Ejecutar la aplicación:

```bash
flutter run
```

## Calidad y pruebas

```bash
flutter analyze
flutter test
```

Las pruebas actuales cubren:

- Credenciales válidas e inválidas.
- Filtrado de tareas por estado.
- Limpieza y preparación de datos antes de guardar.

## Funcionamiento offline y sincronización

Las operaciones se guardan inmediatamente en ObjectBox y funcionan sin conexión. La aplicación muestra el mensaje **“Guardada en este dispositivo”** para comunicar que la persistencia local terminó correctamente.

No se muestra **“Tarea sincronizada”** porque la prueba no proporciona:

- Backend o URL base.
- Endpoints y contrato REST.
- Autenticación remota.
- Identificadores remotos.
- Estrategia de resolución de conflictos.

Por esa razón, afirmar que existe sincronización remota sería incorrecto. La arquitectura permite agregar una fuente remota al repositorio cuando exista un contrato de API definido.

Una implementación posterior incorporaría:

1. Identificador remoto y estado de sincronización por tarea.
2. Cola local de cambios pendientes.
3. Detección de conectividad como disparador, no como garantía de acceso al servidor.
4. Reintentos con espera progresiva.
5. Eliminación diferida mediante `deletedAt`.
6. Resolución de conflictos definida por producto o backend.

## Decisiones técnicas

- Se eligió ObjectBox por su rendimiento, consultas reactivas y funcionamiento local.
- GetX se usa para estado y navegación, evitando colocar persistencia o reglas de negocio dentro de los widgets.
- Los títulos duplicados están permitidos porque dos tareas válidas pueden describir actividades similares.
- `createdAt` se conserva durante la edición y `updatedAt` cambia en cada modificación.
- La descripción vacía se normaliza a `null`.
- El login local se mantiene deliberadamente sencillo porque la prueba está centrada en la gestión offline de tareas.

## Limitaciones conocidas

- No existe sincronización con backend por falta de contrato remoto.
- El login utiliza credenciales fijas y no debe emplearse en producción.
- No se implementó autenticación segura ni manejo de múltiples usuarios.
- No existe paginación porque el alcance actual utiliza un conjunto local pequeño.
- Android 12 aplica una máscara obligatoria al primer ícono del splash nativo. Después se presenta un splash Flutter con el logotipo completo.

## Mejoras futuras

- Sincronización REST con resolución de conflictos.
- Autenticación segura.
- Búsqueda y ordenamiento.
- Paginación para volúmenes grandes.
- Pruebas de integración y widgets adicionales.
- Registro estructurado de errores.
- Accesibilidad y localización.
