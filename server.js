var express = require("express"),
    app = express();

console.log("Serving content on 3030...");

app.use(express.static(__dirname + '/dist'));
app.listen(3030);