import { Router } from "express"

const router = Router()

import {getUser, WelcomeResponse} from '../controllers/login.controller'

router.route('/').get( WelcomeResponse )

export default router