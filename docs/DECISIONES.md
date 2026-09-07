# Decisiones técnicas del proyecto

## 2026-09-06 Stack inicial

Se adopta como base de trabajo:

- Node.js + TypeScript + NestJS para el backend.
- Prisma como ORM y herramienta de migraciones.
- MySQL en Docker Compose para desarrollo.
- React Native + Expo para la aplicación móvil.
- React + TypeScript para el panel web.

## Interfaces

Se utilizará una aplicación móvil con pantallas según el rol: Usuario/Cliente, Empleado y Administrador/Dueño/Gerente.

También se desarrollará un panel web adaptable para la gestión detallada del Empleado y del Administrador/Dueño/Gerente.

## Conectividad

La primera versión funcionará principalmente en línea. Se contemplará una mejora posterior para permitir al Empleado registrar operaciones temporalmente sin conexión y sincronizarlas cuando se restablezca la red.

## Reserva y Cochera

Una reserva futura no modifica el estado operativo de la Cochera ni aparece en el mapa general. Durante el proceso de reserva, el sistema debe impedir seleccionar una Cochera reservada en el período elegido y mostrarla como no disponible para ese período.
