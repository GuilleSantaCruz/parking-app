-- CreateTable
CREATE TABLE `Usuario` (
    `id_usuario` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(50) NOT NULL,
    `apellido` VARCHAR(50) NOT NULL,
    `dni` VARCHAR(10) NOT NULL,
    `email` VARCHAR(100) NOT NULL,
    `contrasena` VARCHAR(100) NOT NULL,
    `telefono` VARCHAR(20) NOT NULL,
    `fecha_registro` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `ciudad` VARCHAR(40) NOT NULL,
    `estado` ENUM('Activo', 'Inactivo') NOT NULL DEFAULT 'Activo',

    UNIQUE INDEX `Usuario_dni_key`(`dni`),
    UNIQUE INDEX `Usuario_email_key`(`email`),
    PRIMARY KEY (`id_usuario`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Vehiculo` (
    `id_vehiculo` INTEGER NOT NULL AUTO_INCREMENT,
    `patente` VARCHAR(15) NOT NULL,
    `modelo` VARCHAR(20) NOT NULL,
    `tipo` ENUM('Auto', 'Moto', 'Camioneta') NOT NULL,
    `id_usuario` INTEGER NOT NULL,

    UNIQUE INDEX `Vehiculo_patente_key`(`patente`),
    PRIMARY KEY (`id_vehiculo`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Dueno` (
    `id_dueno` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(30) NOT NULL,
    `apellido` VARCHAR(50) NOT NULL,
    `dni` VARCHAR(10) NOT NULL,
    `email` VARCHAR(100) NOT NULL,
    `contrasena` VARCHAR(100) NOT NULL,
    `telefono` VARCHAR(20) NOT NULL,

    UNIQUE INDEX `Dueno_dni_key`(`dni`),
    UNIQUE INDEX `Dueno_email_key`(`email`),
    PRIMARY KEY (`id_dueno`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `PlayaEstacionamiento` (
    `id_playa` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(30) NOT NULL,
    `direccion` VARCHAR(60) NOT NULL,
    `telefono` VARCHAR(20) NOT NULL,
    `hora_apertura` TIME(0) NOT NULL,
    `hora_cierre` TIME(0) NOT NULL,
    `capacidad` INTEGER NOT NULL,
    `permite_reservas` BOOLEAN NOT NULL DEFAULT false,
    `id_dueno` INTEGER NOT NULL,

    PRIMARY KEY (`id_playa`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Empleado` (
    `id_empleado` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(30) NOT NULL,
    `apellido` VARCHAR(50) NOT NULL,
    `dni` VARCHAR(10) NOT NULL,
    `email` VARCHAR(100) NOT NULL,
    `contrasena` VARCHAR(100) NOT NULL,
    `telefono` VARCHAR(20) NOT NULL,
    `cargo` VARCHAR(25) NOT NULL,
    `estado` ENUM('Activo', 'Inactivo') NOT NULL DEFAULT 'Activo',
    `id_playa` INTEGER NOT NULL,

    UNIQUE INDEX `Empleado_dni_key`(`dni`),
    UNIQUE INDEX `Empleado_email_key`(`email`),
    PRIMARY KEY (`id_empleado`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Cochera` (
    `id_cochera` INTEGER NOT NULL AUTO_INCREMENT,
    `numero` VARCHAR(10) NOT NULL,
    `tipo_vehiculo` ENUM('Auto', 'Moto', 'Camioneta') NOT NULL,
    `estado` ENUM('Disponible', 'Ocupado', 'FueraDeServicio') NOT NULL DEFAULT 'Disponible',
    `ubicacion` VARCHAR(30) NOT NULL,
    `id_playa` INTEGER NOT NULL,
    `id_tarifa` INTEGER NOT NULL,

    UNIQUE INDEX `Cochera_id_playa_numero_key`(`id_playa`, `numero`),
    PRIMARY KEY (`id_cochera`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Tarifa` (
    `id_tarifa` INTEGER NOT NULL AUTO_INCREMENT,
    `descripcion` VARCHAR(30) NOT NULL,
    `precio_hora` DECIMAL(10, 2) NOT NULL,
    `id_playa` INTEGER NOT NULL,

    PRIMARY KEY (`id_tarifa`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Reserva` (
    `id_reserva` INTEGER NOT NULL AUTO_INCREMENT,
    `fecha_reserva` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `ingreso` DATETIME(3) NOT NULL,
    `salida_estimada` DATETIME(3) NOT NULL,
    `monto_sena` DECIMAL(10, 2) NOT NULL,
    `estado` ENUM('Pendiente', 'Confirmada', 'Cancelada', 'Utilizada', 'Vencida') NOT NULL DEFAULT 'Pendiente',
    `id_usuario` INTEGER NOT NULL,
    `id_vehiculo` INTEGER NOT NULL,
    `id_cochera` INTEGER NOT NULL,

    INDEX `Reserva_id_cochera_ingreso_salida_estimada_idx`(`id_cochera`, `ingreso`, `salida_estimada`),
    PRIMARY KEY (`id_reserva`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Estadia` (
    `id_estadia` INTEGER NOT NULL AUTO_INCREMENT,
    `fecha_ingreso` DATETIME(3) NOT NULL,
    `fecha_salida` DATETIME(3) NULL,
    `monto_total` DECIMAL(10, 2) NULL,
    `estado` ENUM('Activa', 'Finalizada') NOT NULL DEFAULT 'Activa',
    `id_usuario` INTEGER NOT NULL,
    `id_vehiculo` INTEGER NOT NULL,
    `id_cochera` INTEGER NOT NULL,
    `id_empleado` INTEGER NULL,

    INDEX `Estadia_id_vehiculo_estado_idx`(`id_vehiculo`, `estado`),
    PRIMARY KEY (`id_estadia`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Pago` (
    `id_pago` INTEGER NOT NULL AUTO_INCREMENT,
    `fecha_pago` DATETIME(3) NOT NULL,
    `monto` DECIMAL(10, 2) NOT NULL,
    `metodo` ENUM('Efectivo', 'Debito', 'Credito', 'Transferencia', 'MercadoPago') NOT NULL,
    `estado` ENUM('Pendiente', 'Aprobado', 'Rechazado', 'Cancelado') NOT NULL DEFAULT 'Pendiente',
    `id_reserva` INTEGER NULL,
    `id_estadia` INTEGER NULL,

    INDEX `Pago_id_reserva_idx`(`id_reserva`),
    INDEX `Pago_id_estadia_idx`(`id_estadia`),
    PRIMARY KEY (`id_pago`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Notificacion` (
    `id_notificacion` INTEGER NOT NULL AUTO_INCREMENT,
    `titulo` VARCHAR(100) NOT NULL,
    `mensaje` TEXT NOT NULL,
    `tipo` VARCHAR(40) NOT NULL,
    `fecha_envio` DATETIME(3) NOT NULL,
    `leida` BOOLEAN NOT NULL DEFAULT false,
    `id_usuario` INTEGER NOT NULL,

    PRIMARY KEY (`id_notificacion`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `Vehiculo` ADD CONSTRAINT `Vehiculo_id_usuario_fkey` FOREIGN KEY (`id_usuario`) REFERENCES `Usuario`(`id_usuario`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `PlayaEstacionamiento` ADD CONSTRAINT `PlayaEstacionamiento_id_dueno_fkey` FOREIGN KEY (`id_dueno`) REFERENCES `Dueno`(`id_dueno`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Empleado` ADD CONSTRAINT `Empleado_id_playa_fkey` FOREIGN KEY (`id_playa`) REFERENCES `PlayaEstacionamiento`(`id_playa`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Cochera` ADD CONSTRAINT `Cochera_id_playa_fkey` FOREIGN KEY (`id_playa`) REFERENCES `PlayaEstacionamiento`(`id_playa`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Cochera` ADD CONSTRAINT `Cochera_id_tarifa_fkey` FOREIGN KEY (`id_tarifa`) REFERENCES `Tarifa`(`id_tarifa`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Tarifa` ADD CONSTRAINT `Tarifa_id_playa_fkey` FOREIGN KEY (`id_playa`) REFERENCES `PlayaEstacionamiento`(`id_playa`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Reserva` ADD CONSTRAINT `Reserva_id_usuario_fkey` FOREIGN KEY (`id_usuario`) REFERENCES `Usuario`(`id_usuario`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Reserva` ADD CONSTRAINT `Reserva_id_vehiculo_fkey` FOREIGN KEY (`id_vehiculo`) REFERENCES `Vehiculo`(`id_vehiculo`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Reserva` ADD CONSTRAINT `Reserva_id_cochera_fkey` FOREIGN KEY (`id_cochera`) REFERENCES `Cochera`(`id_cochera`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Estadia` ADD CONSTRAINT `Estadia_id_usuario_fkey` FOREIGN KEY (`id_usuario`) REFERENCES `Usuario`(`id_usuario`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Estadia` ADD CONSTRAINT `Estadia_id_vehiculo_fkey` FOREIGN KEY (`id_vehiculo`) REFERENCES `Vehiculo`(`id_vehiculo`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Estadia` ADD CONSTRAINT `Estadia_id_cochera_fkey` FOREIGN KEY (`id_cochera`) REFERENCES `Cochera`(`id_cochera`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Estadia` ADD CONSTRAINT `Estadia_id_empleado_fkey` FOREIGN KEY (`id_empleado`) REFERENCES `Empleado`(`id_empleado`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Pago` ADD CONSTRAINT `Pago_id_reserva_fkey` FOREIGN KEY (`id_reserva`) REFERENCES `Reserva`(`id_reserva`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Pago` ADD CONSTRAINT `Pago_id_estadia_fkey` FOREIGN KEY (`id_estadia`) REFERENCES `Estadia`(`id_estadia`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Notificacion` ADD CONSTRAINT `Notificacion_id_usuario_fkey` FOREIGN KEY (`id_usuario`) REFERENCES `Usuario`(`id_usuario`) ON DELETE RESTRICT ON UPDATE CASCADE;
