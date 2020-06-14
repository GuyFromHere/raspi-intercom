const axios = require("axios");
const express = require("express");
const router = express.Router();
const config = require("config");
const Message = require("../models/Message");

console.log()
// @route   GET /api/message/
// @desc    Gets all messages in the current database
// @access  Public
router.get("/", (req, res) => {
    console.log('server api get /')
    // get messages currently in the database
    Message.find().then(result => {
        if ( result.length > 0 ) {
            //res.json(result);
            res.json({ status: "shockingly there are messages" });
        } else {
            res.json({ status: "no messages" });
        }
    })
})

// @route   POST /api/messate/send/
// @desc    Posts the recorded message to the target database
// @access  Public
router.post("/send", (req, res) => {
    // get recorded message data and store it in the database
    const newObj = req.body;
    // send result to DB on the other device...
    Message.create(newObj).then(result => {
        res.json(result)
    })
})

module.exports = router;