### **Project Description**

WanderLog is a minimalist travel blogging website where users can anonymously share their travel stories, reflections, and photos — no registration, no profiles, just pure storytelling.

The platform emphasizes **simplicity**, **privacy**, and **authenticity**. Every post is immutable once published, ensuring that stories capture the raw emotion of the moment. Readers can browse, comment, and engage anonymously, turning WanderLog into a peaceful, collective space for travel memories.

------

### **Personas**

**Persona 1: The Shy Storyteller — Emily (21)**

- **Goal:** Share travel experiences without revealing her identity.
- **Frustrations:** Feels uncomfortable sharing personal reflections publicly.
- **How WanderLog Helps:** Enables fully anonymous publishing with instant visibility.

**Persona 2: The Reader and Commenter — David (27)**

- **Goal:** Read and comment freely.
- **Frustrations:** Dislikes registration requirements and influencer-dominated content.
- **How WanderLog Helps:** Allows seamless, anonymous commenting — like signing a traveler’s guestbook.

**Persona 3: The Moment Keeper — Mia (30)**

- **Goal:** Capture quick reflections during trips.
- **Frustrations:** Finds editing tedious; prefers raw, unfiltered posts.
- **How WanderLog Helps:** Posts are permanent and uneditable, preserving authenticity.

------

### **Feature Overview**

- **Anonymous Posting:** Write and publish stories instantly, with optional photo uploads.
- **Immutable Content:** No edits or deletions; all posts are timestamped automatically.
- **Anonymous Comments:** Readers can contribute without revealing identity.
- **Blog Feed:** Displays all posts in reverse chronological order, filterable by keyword or destination.
- **Engagement Metrics:** Anonymous “likes” to promote interaction.
- **Minimalist Interface:** Clean, distraction-free design focused on storytelling.

------

### **Detailed Role Responsibilities**

#### **Kangning Li — Data & System Design Lead**

- Design the **database schema** for posts, comments, and engagement data in MongoDB.
- Implement **immutability logic** to prevent edits and deletions.
- Develop **RESTful API endpoints** for post submission, commenting, and liking.
- Handle **media storage management** and data validation.
- Collaborate with the front-end engineer to define data exchange formats (JSON schemas).

#### **Kewen Xu — User Interaction & Experience Lead**

- Design and implement the **user-facing interface** using React.js.
- Build functional modules for **post creation**, **feed display**, and **commenting**.
- Integrate front-end components with backend APIs and ensure a **seamless anonymous workflow**.
- Conduct **usability testing** and optimize layout responsiveness and accessibility.
- Manage **UI consistency** and visual storytelling aesthetics across pages.

------

### **Collaborative Responsibilities**

- Jointly define **API contracts** and ensure consistent data flow between client and server.
- Co-develop and test **deployment pipeline** (Render for backend, Vercel for frontend).
- Perform **integration testing** to verify full-stack functionality and data persistence.
- Prepare **documentation** and final project presentation.

------

### **Tech Stack**

- **Frontend:** React.js, HTML5, CSS3, Bootstrap
- **Backend:** Node.js (Express.js)
- **Database:** MongoDB (Atlas)
- **Image Storage:** Local file system or Firebase Storage
- **Deployment:** Vercel (frontend), Render/Railway (backend)

------

### **Motivation & Expected Outcome**

WanderLog restores the purity of online storytelling — without followers, usernames, or social pressure.

By project completion, we will deliver a **fully functional**, **privacy-conscious**, and **aesthetically minimal** blogging platform that showcases:

- Proper **RESTful architecture**,
- **Frontend–backend integration**,
- **Immutable data design**, and
- A focus on **authentic user experience**.



📋 update脚本使用步骤：

  1. 上传脚本到服务器

  scp update.sh root@8.221.125.31:/opt/WanderLog/

  2. 连接到服务器

  ssh root@8.221.125.31

  3. 运行更新脚本

  cd /opt/WanderLog
  chmod +x update.sh
  ./update.sh

