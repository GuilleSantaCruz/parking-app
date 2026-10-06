import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class HealthService {
  constructor(private readonly prisma: PrismaService) {}

  async check() {
    const usuarios = await this.prisma.usuario.count();

    return {
      status: 'ok',
      database: 'connected',
      usuarios,
    };
  }
}
