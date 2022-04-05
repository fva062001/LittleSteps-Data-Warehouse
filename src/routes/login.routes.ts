import { Router } from "express"

const router = Router()

import { WelcomeResponse, userExists} from '../controllers/login.controller'

router.route('/')
    .get( WelcomeResponse )

router.route('/:id/:password')
    .get( userExists )

export default router