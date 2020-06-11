const axios = require("axios");
const express = require("express");
const router = express.Router();
const config = require("config");
const Message = require("../models/Message");

router.post("/send", (req, res) => {
    // get recorded message data and store it in the database
    const newObj = req.body;
    // send result to DB on the other device...
    Message.create(newObj).then(result => {
        res.json(result)
    })
})