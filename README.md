# CD Mujer - Gestión de préstamos

Base inicial de una aplicación Flutter para la futura gestión de préstamos de CD Mujer. Esta primera etapa se concentra exclusivamente en una estructura limpia, navegación y configuración visual; no incluye lógica de negocio, autenticación, almacenamiento ni conexión a servicios externos.

## Arquitectura

El proyecto usa una organización **Feature First**. Cada módulo crece de forma independiente y, cuando lo requiera, podrá dividirse en las capas `presentation`, `domain` y `data`.

- `presentation`: pantallas, widgets y estado de interfaz.
- `domain`: entidades y casos de uso de la funcionalidad.
- `data`: repositorios, fuentes de datos y modelos de persistencia/API.

Las capas `domain` y `data` se crearán únicamente cuando cada módulo las necesite.

## Estructura principal

```text
lib/
├── app/
│   ├── app.dart
│   ├── router/
│   └── theme/
├── core/
│   └── widgets/
├── features/
│   ├── clients/presentation/pages/
│   ├── home/presentation/{pages,widgets}/
│   ├── loans/presentation/pages/
│   └── payments/presentation/pages/
└── main.dart
```

## Ejecutar el proyecto

1. Instala una versión estable reciente de [Flutter](https://docs.flutter.dev/get-started/install) y verifica que `flutter` esté disponible en tu terminal.
2. Desde la raíz del proyecto, ejecuta en ambiente de desarrollo:

   ```bash
   flutter pub get
   flutter run --dart-define=APP_ENV=dev
   ```

   `dev` usa `https://localhost:7127` y es el ambiente predeterminado, por lo
   que `flutter run` conserva el mismo comportamiento.

3. Para ejecutar la aplicación contra el ambiente de QA:

   ```bash
   flutter run --dart-define=APP_ENV=qa
   ```

   QA usa
   `https://cdmujer-api-dsfugwdqb2efdjf2.westus3-01.azurewebsites.net`.

4. Para generar un APK de cualquiera de los ambientes:

   ```bash
   flutter build apk --release --dart-define=APP_ENV=dev
   flutter build apk --release --dart-define=APP_ENV=qa
   ```

5. Para revisar la calidad estática del código:

   ```bash
   flutter analyze
   ```

## Módulos planeados

- Clientes
- Préstamos
- Pagos

El proyecto se encuentra en una etapa inicial. Estas secciones son actualmente pantallas de navegación y no implementan funcionalidades de gestión.
