const config = {
    server: 'SQL_SERVER=SQL5107.site4now.net',  //update me
        authentication: {
            type: 'default',
            options: {
                userName: 'db_a83ca8_littlestepsdw_admin', //update me
                password: 'AliciaGOD12'  //update me
            }
        },
        options: {
            // If you are on Microsoft Azure, you need encryption:
            encrypt: false,
            database: 'db_a83ca8_littlestepsdw'  //update me
        }
}

export default config;