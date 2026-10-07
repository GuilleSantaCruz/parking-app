import { Body, Controller, Get, Post, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { RolesGuard } from '../auth/guards/roles.guard';
import { CrearUsuarioDto } from './dto/crear-usuario.dto';
import { UsuariosService } from './usuarios.service';

@Controller('usuarios')
export class UsuariosController {
  constructor(private readonly usuariosService: UsuariosService) {}

  @Get()
  @Roles('Empleado', 'Administrador')
  @UseGuards(JwtAuthGuard, RolesGuard)
  listar() {
    return this.usuariosService.listar();
  }

  @Post()
  crear(@Body() datos: CrearUsuarioDto) {
    return this.usuariosService.crear(datos);
  }
}
