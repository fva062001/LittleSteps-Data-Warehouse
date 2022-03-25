import {Request, Response} from 'express'
import { connect } from '../db'
import path from 'path'

export async function getUsers(req: Request, res: Response){
    const conn = await connect()
    const users = await conn.query('SELECT * FROM usuarios')
    res.json(users)
}

export async function userExists(req: Request, res: Response): Promise<Response>{
    var set
    const conn = await connect()

    set = await conn.query(`select * from usuarios where id_usuario=\'${req.params.id}\' and pwd=\'${req.params.password}\'`)

    return res.json({
        exists: set.rowsAffected[0] > 0 ? true : false
    })
}

export function WelcomeResponse(req: Request, res: Response){
    res.sendFile(path.join(__dirname,"../../dist/login.html"))
}