import StatusCodes from 'http-status-codes';
import { Request, Response, Router } from 'express';

import userService from '@services/user-service';
import { ParamMissingError } from '@shared/errors';

import sql from 'mssql'



// Constants
const router = Router();
const { CREATED, OK } = StatusCodes;

// Paths
export const p = {
    has: '/has'
} as const;


/**
 * Encontrar usuario para login
 */
 router.get(p.has, (req_: Request, res: Response) => {
    const user = req_.body;
    const users = userService.has(user).then(() => {
        return res.status(OK).send();
    });
});

/**
 * Get all users.
 */
router.get(p.get, async (_: Request, res: Response) => {
    
    const users = await userService.getAll();
    return res.status(OK).json({users});
});


// Export default
export default router;
