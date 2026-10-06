import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcryptjs';
import { PrismaService } from '../prisma/prisma.service';
import { LoginDto } from './dto/login.dto';

type Rol = 'Usuario' | 'Empleado' | 'Administrador';

type CuentaEncontrada = {
  id: number;
  email: string;
  contrasena: string;
  estado?: string;
  rol: Rol;
  nombre: string;
  apellido: string;
};

@Injectable()
export class AuthService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly jwtService: JwtService,
  ) {}

  async login(datos: LoginDto) {
    const cuenta = await this.buscarCuenta(datos.email);

    if (!cuenta || (cuenta.estado && cuenta.estado !== 'Activo')) {
      throw new UnauthorizedException('Email o contraseña incorrectos');
    }

    const contrasenaValida = await bcrypt.compare(
      datos.contrasena,
      cuenta.contrasena,
    );

    if (!contrasenaValida) {
      throw new UnauthorizedException('Email o contraseña incorrectos');
    }

    const payload = {
      sub: cuenta.id,
      email: cuenta.email,
      rol: cuenta.rol,
    };

    const accessToken = await this.jwtService.signAsync(payload);

    return {
      mensaje: 'Inicio de sesión exitoso',
      accessToken,
      perfil: {
        id: cuenta.id,
        nombre: cuenta.nombre,
        apellido: cuenta.apellido,
        email: cuenta.email,
        rol: cuenta.rol,
      },
    };
  }

  private async buscarCuenta(email: string): Promise<CuentaEncontrada | null> {
    const usuario = await this.prisma.usuario.findUnique({
      where: { email },
      select: {
        id: true,
        nombre: true,
        apellido: true,
        email: true,
        contrasena: true,
        estado: true,
      },
    });

    if (usuario) {
      return { ...usuario, rol: 'Usuario' };
    }

    const empleado = await this.prisma.empleado.findUnique({
      where: { email },
      select: {
        id: true,
        nombre: true,
        apellido: true,
        email: true,
        contrasena: true,
        estado: true,
      },
    });

    if (empleado) {
      return { ...empleado, rol: 'Empleado' };
    }

    const dueno = await this.prisma.dueno.findUnique({
      where: { email },
      select: {
        id: true,
        nombre: true,
        apellido: true,
        email: true,
        contrasena: true,
      },
    });

    if (dueno) {
      return { ...dueno, rol: 'Administrador' };
    }

    return null;
  }
}
