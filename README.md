# Sistema de Gestión de Estacionamientos

Proyecto universitario para gestionar playas de estacionamiento, cocheras, vehículos, reservas, estadías, pagos y reportes.

## Stack definido

- Backend: Node.js, TypeScript, NestJS y Prisma.
- Base de datos: MySQL ejecutado mediante Docker Compose.
- Aplicación móvil: React Native con Expo.
- Panel web: React y TypeScript.
- Control de versiones: Git y GitHub.

## Primeros pasos

1. Copiar `.env.example` como `.env`.
2. Iniciar la base de datos:

   ```bash
   docker compose up -d
   ```

3. Comprobar el contenedor:

   ```bash
   docker compose ps
   ```

El backend, las migraciones y las aplicaciones se agregarán en los directorios correspondientes.

## Organización

- `backend/`: API y reglas de negocio.
- `mobile/`: aplicación móvil para Cliente, Empleado y Administrador.
- `web/`: panel web para gestión.
- `database/`: documentación y recursos de base de datos.
- `docs/`: decisiones, casos de uso y acuerdos del equipo.

## Flujo de trabajo

- `main` debe mantenerse estable.
- Cada funcionalidad se desarrolla en una rama `feature/...`.
- Los cambios se integran mediante Pull Request.
- Los cambios de estructura de la base de datos se realizan mediante migraciones.
- No se suben archivos `.env` ni contraseñas reales.
