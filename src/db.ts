import sql, { ConnectionPool } from "mssql"
require('dotenv').config()

export async function connect():Promise<ConnectionPool>{
    try{
        return sql.connect(process.env.DB_CONN?.toString() || "")
    }catch(err){
        throw err
    }
}
