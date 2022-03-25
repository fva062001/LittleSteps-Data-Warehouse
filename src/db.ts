import sql, { ConnectionPool } from "mssql"
require('dotenv').config()

export async function connect():Promise<ConnectionPool>{
    await console.log(process.env.DB_CONN?.slice(1,-1).toString())
    try{
        return sql.connect(process.env.DB_CONN?.toString() || "err")
    }catch(err){
        throw err
    }
}
