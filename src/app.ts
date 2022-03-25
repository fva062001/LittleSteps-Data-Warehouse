import express, {Application} from "express"
import morgan from "morgan"

//Rutas
import indexRoutes from './routes/index.routes'
import loginRoutes from './routes/login.routes'

require('dotenv').config()

export class App{
    private app: Application

    constructor(private port?: number | string){
        this.app = express()
        this.settings()
        this.middlewares()
        this.routes()
    }

    settings(){
        this.app.set('port', this.port || process.env.PORT || 3000)
    }

    middlewares(){
        this.app.use(morgan('dev'))
        this.app.use(express.json())
        this.app.use(express.static('dist'))
    }

    routes(){
        this.app.use(loginRoutes)
        this.app.use('/app',indexRoutes)
    }

    async listen(){
        await this.app.listen(this.app.get('port')).on("error", function(err){
            process.once("SIGUSR2", function(){
                process.kill(process.pid, "SIGUSR2")
            })
            process.on("SIGINT", function(){
                process.kill(process.pid, "SIGINT")
            })
        })
        console.log("Server on port: ",this.app.get('port'))
    }
}