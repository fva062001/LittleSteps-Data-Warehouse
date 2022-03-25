import {Request, Response} from 'express'
import sql from 'mssql'
import { connect } from '../db'
import path from 'path'
import { Usuario } from '../interfaces/Usuario'

export async function getUsers(req: Request, res: Response){
    const conn = await connect()
    const users = await conn.query('SELECT * FROM usuarios')
    res.json(users)
}

export async function userExists(req: Request, res: Response): Promise<Response>{
    var set
    const conn = await connect()

    set = await conn.query(`select * from usuarios where id_usuario=\'${req.params.id}\' and pwd=\'${req.params.password}\'`)

    //*
    //*         PREPARED STATEMENTE QUE NO SIRVE TODAVIA
    //*
    // const ps = new sql.PreparedStatement(conn)
    //     .input('id', sql.VarChar)
    //     .input('pass', sql.VarChar)
    // const query = "select * from usuarios where id_usuario=\'@id\' and pwd=\'@pass\'"
    // console.log(query)
    // ps.prepare(query, err => {
    //     if(err){
    //         throw err
    //     }
    //     ps.execute({id: req.params.id, pass: req.params.password}, (err, result) => {
    //         if(err) throw err
    //         console.log(result?.recordset)
    //         set = result
    //         ps.unprepare(err => {
    //             if(err) throw err
    //         })
    //         conn.close()
    //     })
    // })

    console.log(set)
    return res.json({
        exists: set.rowsAffected[0] > 0 ? true : false
    })
}

export function WelcomeResponse(req: Request, res: Response){
    res.sendFile(path.join(__dirname,"../../dist/login.html"))
}