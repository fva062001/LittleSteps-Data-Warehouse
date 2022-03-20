import sql from "mssql"
import config from "../repos/database"

async function connectDB() {
  try {
    const pool = await sql.connect(config)

    console.log("Conexion exitosa")
    return pool
  } catch (error) {
    console.log("Error de conexion")
  }
}

async function getUser(id: string) {
  try {
    await sql.connect(config)
    const result = await sql.query(`select * from usuarios where usuario_id=${id}`)
    if (result != null) {
      if (result.recordset[0] > 0) return true
      else return false
    }
  } catch (err) {
    console.log(err)
  }
}

export default {
  connect: connectDB,
  findUser: getUser
}
