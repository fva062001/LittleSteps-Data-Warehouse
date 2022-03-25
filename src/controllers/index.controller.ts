import {Request, Response} from 'express'
import path from 'path'

export function WelcomeResponse(req: Request, res: Response): Response{
    res.sendFile(path.join(__dirname+'/index.html'))
    return res.json("Esta es la API")
}