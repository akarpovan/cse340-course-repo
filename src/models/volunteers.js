import db from './db.js';

/**
 * Add a user as a volunteer for a project
 * @param {number} userId
 * @param {number} projectId
 * @returns {Promise<object>} - the new volunteer record
 */
const addVolunteer = async (userId, projectId) => {
    const query = `
        INSERT INTO volunteer (user_id, project_id)
        VALUES ($1, $2)
        RETURNING volunteer_id
    `;
    const result = await db.query(query, [userId, projectId]);
    return result.rows[0];
};

/**
 * Remove a user as a volunteer from a project
 * @param {number} userId
 * @param {number} projectId
 */
const removeVolunteer = async (userId, projectId) => {
    const query = `
        DELETE FROM volunteer
        WHERE user_id = $1 AND project_id = $2
    `;
    await db.query(query, [userId, projectId]);
};

/**
 * Check if a user is already volunteering for a project
 * @param {number} userId
 * @param {number} projectId
 * @returns {Promise<boolean>}
 */
const isVolunteering = async (userId, projectId) => {
    const query = `
        SELECT 1 FROM volunteer
        WHERE user_id = $1 AND project_id = $2
    `;
    const result = await db.query(query, [userId, projectId]);
    return result.rows.length > 0;
};

/**
 * Get all projects a user has volunteered for
 * @param {number} userId
 * @returns {Promise<Array>} - list of project objects
 */
const getVolunteerProjectsByUserId = async (userId) => {
    const query = `
        SELECT
            p.project_id,
            p.title,
            p.description,
            p.date,
            p.location,
            o.name AS organization_name
        FROM volunteer v
        JOIN project p ON v.project_id = p.project_id
        JOIN organization o ON p.organization_id = o.organization_id
        WHERE v.user_id = $1
        ORDER BY p.date ASC
    `;
    const result = await db.query(query, [userId]);
    return result.rows;
};

export { addVolunteer, removeVolunteer, isVolunteering, getVolunteerProjectsByUserId };