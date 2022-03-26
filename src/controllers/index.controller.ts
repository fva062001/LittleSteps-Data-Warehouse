import {Request, Response} from 'express'
import path from 'path'

export function WelcomeResponse(req: Request, res: Response){
    res.sendFile(path.join(__dirname+'../../../dist/app.html'))
}