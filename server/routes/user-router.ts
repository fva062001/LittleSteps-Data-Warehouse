import StatusCodes from "http-status-codes"
import { Request, Response, Router } from "express"

import userService from "../repos/user-repo"

// Constants
const router = Router()
const { OK } = StatusCodes

// Paths
export const p = {
  has: "/has"
} as const

/**
 * Encontrar usuario para login
 */
router.get(p.has, (req_: Request, res: Response) => {
  const user = req_.body
  const users = userService.has(user).then(() => {
    return res.status(OK).send()
  })
})

// Export default
export default router
