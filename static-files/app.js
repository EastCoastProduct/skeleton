'use strict';

const express = require('express');
const app = express();
const path = require('path');
const port = process.env.PORT || 4000;

app.use(express.static(path.join(__dirname, 'src')));

app.listen(port, function() {
  console.log('Static files listening on port', port);
});
