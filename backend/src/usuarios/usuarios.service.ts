import { ConflictException, Injectable } from '@nestjs/common';
import * as bcrypt from 'bcryptjs';
import { PrismaService } from '../prisma/prisma.service';
import { CrearUsuarioDto } from './dto/crear-usuario.dto';

@Injectable()
export class UsuariosService {
  constructor(private readonly prisma: PrismaService) {}

  async listar() {
    return this.prisma.usuario.findMany({
      select: {
        id: true,
        nombre: true,
        apellido: true,
        dni: true,
        email: true,
        telefono: true,
        fechaRegistro: true,
        ciudad: true,
        estado: true,
      },
      orderBy: { id: 'asc' },
    });
  }

  async crear(datos: CrearUsuarioDto) {
    const contrasenaHash = await bcrypt.hash(datos.contrasena, 10);

    try {
      return await this.prisma.usuario.create({
        data: {
          ...datos,
          contrasena: contrasenaHash,
        },
        select: {
          id: true,
          nombre: true,
          apellido: true,
          dni: true,
          email: true,
          telefono: true,
          fechaRegistro: true,
          ciudad: true,
          estado: true,
        },
      });
    } catch (error) {
      if (this.esErrorDeDatoDuplicado(error)) {
        throw new ConflictException('El DNI o el email ya están registrados');
      }

      throw error;
    }
  }

  private esErrorDeDatoDuplicado(error: unknown): boolean {
    return (
      typeof error === 'object' &&
      error !== null &&
      'code' in error &&
      error.code === 'P2002'
    );
  }
}
