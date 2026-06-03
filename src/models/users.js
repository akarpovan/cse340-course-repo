import db from './db.js'
import bcrypt from 'bcrypt';

const createUser = async (name, email, passwordHash) => {
    const default_role = 'user';
    const query = `
        INSERT INTO users (name, email, password_hash, role_id) 
        VALUES ($1, $2, $3, (SELECT role_id FROM roles WHERE role_name = $4)) 
        RETURNING user_id
    `;
    const queryParams = [name, email, passwordHash, default_role];

    const result = await db.query(query, queryParams);

    if (result.rows.length === 0) {
        throw new Error('Failed to create user');
    }

    if (process.env.ENABLE_SQL_LOGGING === 'true') {
        console.log('Created new user with ID:', result.rows[0].user_id);
    }

    return result.rows[0].user_id;
};

/**
 * Find a user by their email address
 * @param {string} email - The user's email address
 * @returns {Promise<object|null>} - Returns user object if found, null if not found
 */
const findUserByEmail = async (email) => {
    const query = `
        SELECT user_id, name, email, password_hash, role_id 
        FROM users 
        WHERE email = $1
    `;
    const queryParams = [email];

    const result = await db.query(query, queryParams);

    if (result.rows.length === 0) {
        return null; // User not found
    }

    return result.rows[0];
};

/**
 * Verify a plain text password against a hashed password
 * @param {string} password - Plain text password from user input
 * @param {string} passwordHash - Hashed password from database
 * @returns {Promise<boolean>} - Returns true if passwords match, false otherwise
 */
const verifyPassword = async (password, passwordHash) => {
    return bcrypt.compare(password, passwordHash);
};

/**
 * Authenticate a user by email and password
 * This is the main function that controllers should use for login
 * @param {string} email - User's email address
 * @param {string} password - User's plain text password
 * @returns {Promise<object|null>} - Returns user object (without password_hash) if authentication succeeds, null if fails
 */
const authenticateUser = async (email, password) => {
    // Step 1: Find the user by email
    const user = await findUserByEmail(email);

    // Step 2: If no user found, return null
    if (!user) {
        return null;
    }

    // Step 3: Verify the password
    const isPasswordValid = await verifyPassword(password, user.password_hash);

    // Step 4: If password is incorrect, return null
    if (!isPasswordValid) {
        return null;
    }

    // Step 5: Password is correct - remove password_hash from user object
    const { password_hash, ...userWithoutPassword } = user;

    // Step 6: Return the user object without the password hash
    return userWithoutPassword;
};

export { createUser, authenticateUser };