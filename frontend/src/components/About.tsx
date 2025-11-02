import React from 'react';

const About: React.FC = () => {
  return (
    <div className="about-container">
      <div className="about-content">
        <section className="readme-section">
          <h2>Project Overview</h2>
          <div className="content-block">
            <h3>WanderLog</h3>
            <p>A minimalist UGC platform where users can anonymously share posts with text and images. Built with React + MongoDB.</p>
            
            <h4>Features</h4>
            <ul>
              <li>Anonymous posting (no login system)</li>
              <li>Posts include title, text content, and up to 6 images</li>
              <li>UUID-based post identification</li>
              <li>Immutable posts (no editing or deletion)</li>
              <li>Simple UI with khaki, black, and white color theme</li>
              <li>Image upload to server storage</li>
            </ul>

            <h4>Tech Stack</h4>
            <ul>
              <li><strong>Frontend:</strong> React with TypeScript</li>
              <li><strong>Backend:</strong> Node.js with Express</li>
              <li><strong>Database:</strong> MongoDB</li>
              <li><strong>File Storage:</strong> Local server storage</li>
            </ul>

            <h4>API Endpoints</h4>
            <ul>
              <li><code>POST /api/posts</code> - Create a new post (with optional image uploads)</li>
              <li><code>GET /api/posts</code> - Get all posts (sorted by creation date, newest first)</li>
              <li><code>GET /api/posts/:id</code> - Get a specific post by UUID</li>
            </ul>
          </div>
        </section>

        <section className="proposal-section">
          <h2>Project Proposal</h2>
          <div className="content-block">
            <h3>Project Description</h3>
            <p>WanderLog is a minimalist travel blogging website where users can anonymously share their travel stories, reflections, and photos — no registration, no profiles, just pure storytelling.</p>
            
            <p>The platform emphasizes <strong>simplicity</strong>, <strong>privacy</strong>, and <strong>authenticity</strong>. Every post is immutable once published, ensuring that stories capture the raw emotion of the moment. Readers can browse, comment, and engage anonymously, turning WanderLog into a peaceful, collective space for travel memories.</p>

            <h4>Personas</h4>
            <div className="persona">
              <h5>The Shy Storyteller — Emily (21)</h5>
              <ul>
                <li><strong>Goal:</strong> Share travel experiences without revealing her identity.</li>
                <li><strong>Frustrations:</strong> Feels uncomfortable sharing personal reflections publicly.</li>
                <li><strong>How WanderLog Helps:</strong> Enables fully anonymous publishing with instant visibility.</li>
              </ul>
            </div>

            <div className="persona">
              <h5>The Reader and Commenter — David (27)</h5>
              <ul>
                <li><strong>Goal:</strong> Read and comment freely.</li>
                <li><strong>Frustrations:</strong> Dislikes registration requirements and influencer-dominated content.</li>
                <li><strong>How WanderLog Helps:</strong> Allows seamless, anonymous commenting — like signing a traveler's guestbook.</li>
              </ul>
            </div>

            <div className="persona">
              <h5>The Moment Keeper — Mia (30)</h5>
              <ul>
                <li><strong>Goal:</strong> Capture quick reflections during trips.</li>
                <li><strong>Frustrations:</strong> Finds editing tedious; prefers raw, unfiltered posts.</li>
                <li><strong>How WanderLog Helps:</strong> Posts are permanent and uneditable, preserving authenticity.</li>
              </ul>
            </div>

            <h4>Feature Overview</h4>
            <ul>
              <li><strong>Anonymous Posting:</strong> Write and publish stories instantly, with optional photo uploads.</li>
              <li><strong>Immutable Content:</strong> No edits or deletions; all posts are timestamped automatically.</li>
              <li><strong>Anonymous Comments:</strong> Readers can contribute without revealing identity.</li>
              <li><strong>Blog Feed:</strong> Displays all posts in reverse chronological order, filterable by keyword or destination.</li>
              <li><strong>Engagement Metrics:</strong> Anonymous "likes" to promote interaction.</li>
              <li><strong>Minimalist Interface:</strong> Clean, distraction-free design focused on storytelling.</li>
            </ul>

            <h4>Motivation & Expected Outcome</h4>
            <p>WanderLog restores the purity of online storytelling — without followers, usernames, or social pressure.</p>
            
            <p>By project completion, we will deliver a <strong>fully functional</strong>, <strong>privacy-conscious</strong>, and <strong>aesthetically minimal</strong> blogging platform that showcases:</p>
            <ul>
              <li>Proper <strong>RESTful architecture</strong></li>
              <li><strong>Frontend–backend integration</strong></li>
              <li><strong>Immutable data design</strong></li>
              <li>A focus on <strong>authentic user experience</strong></li>
            </ul>
          </div>
        </section>
      </div>
    </div>
  );
};

export default About;