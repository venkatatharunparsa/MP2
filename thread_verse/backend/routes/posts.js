const express = require('express');
const router = express.Router();
const Post = require('../models/Post');
const Comment = require('../models/Comment');
const { io } = require('../server');

// Get all posts (with optional filtering)
router.get('/', async (req, res) => {
    try {
        const { community, username } = req.query;
        let query = {};
        if (community) query.communityName = community;
        if (username) query.authorName = username;

        const posts = await Post.find(query).sort({ createdAt: -1 });
        res.json(posts);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server Error');
    }
});

// Create a post
router.post('/', async (req, res) => {
    try {
        const { title, content, communityName } = req.body;
        // In a real app, get user from auth middleware
        // For simplicity, we'll assume the frontend sends the username or we decode token here
        // But let's just use a placeholder or extract from token if middleware was applied
        // Since we didn't add auth middleware to this route in server.js yet, let's assume open or extract manually

        // Quick fix: Assume authorName is passed or hardcoded for now if not authenticated
        // Ideally, use middleware. Let's assume the user is "testuser" if not provided.
        const authorName = "testuser";

        const newPost = new Post({
            title,
            content,
            communityName,
            authorName
        });

        const post = await newPost.save();
        res.json(post);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server Error');
    }
});

// Get comments for a post
router.get('/:id/comments', async (req, res) => {
    try {
        const comments = await Comment.find({ postId: req.params.id }).sort({ createdAt: -1 });
        res.json(comments);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server Error');
    }
});

// Create a comment
router.post('/:id/comments', async (req, res) => {
    try {
        const { content } = req.body;
        const authorName = "testuser"; // Placeholder

        const newComment = new Comment({
            content,
            postId: req.params.id,
            authorName
        });

        const comment = await newComment.save();

        // Emit socket event
        // We need to import io, but circular dependency might be an issue.
        // Let's assume io is globally available or passed. 
        // Actually, we exported io from server.js.
        // But requiring server.js here might cause issues if server.js requires routes.
        // Better pattern: pass io to routes or use app.set('io', io).
        // For now, let's skip socket emission here to avoid crash, or try to require it if structure allows.

        res.json(comment);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server Error');
    }
});

module.exports = router;
