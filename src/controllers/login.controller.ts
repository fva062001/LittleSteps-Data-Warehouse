import {Request, Response} from 'express'
import sql from 'mssql'
import { connect } from '../db'
import path from 'path'

export async function getUser(req: Request, res: Response){
    const conn = await connect()
    
    const users = await conn.query('SELECT * FROM usuarios')
    res.json(users)
}

// const ps = new sql.PreparedStatement(conn).input('id', sql.VarChar).input('pass', sql.VarChar)
// ps.prepare("select * from usuarios where id=@id and pass=@pass", err => {
//     if(err){
//         throw err
//     }
//     ps.execute({id: req.params.id, pass: req.params.pass}, (err, result) => {
//         if(err) throw err
//         //Manejar resultados
//         res.json(result)
//         ps.unprepare(err => {
//             if(err) throw err
//         })
//         conn.close()
//     })
// })

export function WelcomeResponse(req: Request, res: Response): Response{
    return res.json("Esta es la API")
}