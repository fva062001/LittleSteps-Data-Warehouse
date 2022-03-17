import userRepo from '@repos/user-repo';
import { IUser } from '@models/user-model';
import { UserNotFoundError } from '@shared/errors';



/**
 * Get all users.
 * 
 * @return
 */
function foundOne(id: string): Promise<boolean> {
    return userRepo.has(id)
}

// Export default
export default {
    has: foundOne
} as const;
