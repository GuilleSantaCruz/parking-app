import { SetMetadata } from '@nestjs/common';
import { Rol } from '../guards/jwt-auth.guard';

export const ROLES_KEY = 'roles';
export const Roles = (...roles: Rol[]) => SetMetadata(ROLES_KEY, roles);
