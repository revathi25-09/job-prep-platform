const express = require("express");
const cors = require("cors");
const bcrypt = require("bcryptjs");
require("dotenv").config();

const pool = require("./db");

const app = express();

app.use(cors());
app.use(express.json());


// REGISTER USER
app.post("/register", async (req, res) => {
  try {
    const { email, password } = req.body;

    // Check if email and password were provided
    if (!email || !password) {
      return res.status(400).json({
        message: "Email and password are required",
      });
    }

    // Check if email already exists
    const existingUser = await pool.query(
      "SELECT email FROM users WHERE email = $1",
      [email]
    );

    if (existingUser.rows.length > 0) {
      return res.status(409).json({
        message: "Email already registered",
      });
    }

    // Encrypt/hash the password
    const passwordHash = await bcrypt.hash(password, 10);

    // Save user in PostgreSQL
    await pool.query(
      "INSERT INTO users (email, password_hash) VALUES ($1, $2)",
      [email, passwordHash]
    );

    res.status(201).json({
      message: "Registration successful",
    });

  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: "Server error",
    });
  }
});


const PORT = 5000;

app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});