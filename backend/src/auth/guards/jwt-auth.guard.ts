import {
  CanActivate,
  ExecutionContext,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

export type Rol = 'Usuario' | 'Empleado' | 'Administrador';

export type DatosToken = {
  sub: number;
  email: string;
  rol: Rol;
};

@Injectable()
export class JwtAuthGuard implements CanActivate {
  constructor(private readonly jwtService: JwtService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const [tipo, token] = request.headers.authorization?.split(' ') ?? [];

    if (tipo !== 'Bearer' || !token) {
      throw new UnauthorizedException('Debes enviar un token Bearer');
    }

    try {
      request.user = await this.jwtService.verifyAsync<DatosToken>(token);
      return true;
    } catch {
      throw new UnauthorizedException('El token no es válido o ya venció');
    }
  }
}
