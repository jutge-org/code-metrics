
###############################################################################
# system requires
###############################################################################

debug = require("debug") "jutge-code-metrics"
express = require "express"
path = require "path"
favicon = require "serve-favicon"
logger = require "morgan"
cookieParser = require "cookie-parser"
bodyParser = require "body-parser"
fs = require "fs"
childProcess = require "child_process"
uuid = require 'node-uuid'


###############################################################################
# Constants
###############################################################################

dat = "/tmp/dat"



###############################################################################
# Routers
###############################################################################


index = (req, res, next) ->
    res.render 'index',
        title: 'Code Metrics'
        uuid: uuid.v1().replace /-/g, ''


submit = (req, res, next) ->

    id = req.params.id
    code = req.body.code
    path = "#{dat}/#{id}"

    fs.access "#{path}.cc", fs.F_OK, (stat) ->
        if stat
            fs.writeFile "#{path}.cc", code+'\n',  (err) ->
                childProcess.exec "bin/code-metrics.py #{path}.cc", (err, stdout, stderr) ->
                    fs.writeFile "#{path}.json", stdout, (err) ->
                        submission req, res, next
        else
            res.render 'rewrite',
                title: 'Code Metrics'


submission = (req, res, next) ->

    id = req.params.id
    path = "#{dat}/#{id}"

    fs.readFile "#{path}.cc", (err, code) ->
        fs.readFile "#{path}.json", (err, data) ->
            metrics = JSON.parse data
            res.render 'submission',
                title: 'Submission ' + id
                code: code
                metrics: metrics



###############################################################################
# Application
###############################################################################

# create the express app
app = express()


app.use bodyParser.json()
app.use bodyParser.urlencoded
    extended: true


# view engine setup
app.set "views", path.join __dirname, "views"
app.set "view engine", "jade"

# generate javascripts from coffeescripts on the fly for the client
app.use require("connect-coffee-script")
    src    : "#{__dirname}/client"
    dest   : "#{__dirname}/public/javascripts"
    prefix : "/javascripts"

app.use favicon "#{__dirname}/public/favicon.ico"

app.use logger "dev"
app.use cookieParser()
app.use require("stylus").middleware path.join __dirname, "public"



# set static paths
app.use express.static path.join __dirname, "public"
app.use "/bower_components", express.static path.join __dirname, "bower_components"


# set routers
app.get '/', index
app.get '/:id', submission
app.post '/:id', submit


# catch 404 and forward to error handler
app.use (req, res, next) ->
    err = new Error "Not Found"
    err.status = 404
    next err


# development error handler
# will print stacktrace
if app.get("env") is "development"
    app.use (err, req, res, next) ->
        res.status err.status or 500
        res.render "error",
            message: err.message,
            error: err


# pretty print html
if app.get("env") is "development"
    app.locals.pretty = true


# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render "error",
        message: err.message,
        error: {}



###############################################################################
# exports
###############################################################################

module.exports = app

