const express = require('express');
const router = express.Router();
const Community = require('../models/Community');

// Get community details
router.get('/:name', async (req, res) => {
    try {
        const community = await Community.findOne({ name: req.params.name });
        if (!community) {
            // Create if not exists for demo purposes
            const newCommunity = new Community({ name: req.params.name, description: 'Auto-generated community' });
            await newCommunity.save();
            return res.json(newCommunity);
        }
        res.json(community);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server Error');
    }
});

module.exports = router;
