const axios = require("axios");
const express = require("express");
const router = express.Router();
const moment = require('moment');
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
            console.log('GET /api/message');
            const newArr = result.map(item => {
                return newObj = {
                    message: item.message,
                    date: moment(item.date).format('MMMM DD h:mm:ss a'),
                    id: item._id
                }
            })
            //console.log(newArr);
            //res.json(result);
            res.json(newArr);
        } else {
            res.json({ status: "no messages" });
        }
    })
})

// @route   POST /api/message/send/
// @desc    Posts the recorded message to the target database
// @access  Public
router.post("/send", (req, res) => {
    // get recorded message data and store it in the database
    const newObj = {
        message: req.body.message,
        played: false
    };
    // send result to DB on the other device...
    Message.create(newObj).then(result => {
        res.json(result)
    })
})

// @route   POST /api/message/delete/:id
// @desc    Deletes the specified message from the database
// @access  Public
router.post("/delete/:id", (req, res) => {
    console.log('server api delete id ')
    console.log(req.params.id)
    // Delete message with selected ID
    Message.deleteOne({_id: req.params.id}).then((err, result) => {
        if (err) {
            console.log(err);
        } else {
            res.json(result)
        } 
    })
})

module.exports = router;