import { Router } from "express"

const router = Router()

import {WelcomeResponse} from '../controllers/index.controller'

router.route('/').get( WelcomeResponse )

export default router