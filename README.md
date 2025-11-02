# WanderLog

A minimalist UGC platform where users can anonymously share posts with text and images. Built with React + MongoDB.

## 🌍 Live Demo

**Demo URL**: [http://8.221.125.31](http://8.221.125.31)

Experience WanderLog in action! The demo deployment showcases:
- Three-tab navigation (Square/Create New/About)
- Anonymous post creation with image uploads
- Real-time post display and interaction
- Complete project documentation

*Note: This is a test deployment for educational purposes.*

## Features

- **Anonymous posting** (no login system)
- **Posts include** title, text content, and up to 6 images
- **UUID-based** post identification
- **Immutable posts** (no editing or deletion)
- **Dark/Light theme** with system preference detection
- **Real-time search** with debounced filtering and search history
- **Three-tab navigation** (Square/Create New/About)
- **Responsive design** with smooth transitions
- **Image upload** to server storage

## 🚀 Advanced React Features

This project demonstrates modern React development patterns and advanced features:

### **State Management**
- **Context API** with `useReducer` for global theme and search state
- **Custom Hooks** (`useDebounce`, `useTheme`, `useSearch`) for logic reuse
- **Local Storage** integration for theme and search history persistence

### **Performance Optimization**
- **React.memo** for component memoization to prevent unnecessary re-renders
- **useCallback** hooks for optimized event handlers
- **Debounced search** to minimize API calls and improve performance

### **User Experience**
- **Real-time search** with instant filtering and autocomplete suggestions
- **Theme switching** with CSS variables and smooth transitions
- **Search history** with persistent storage and quick access
- **Responsive design** that adapts to different screen sizes

### **Modern React Patterns**
- **Function components** with hooks throughout
- **TypeScript** for type safety and better development experience
- **Custom hook composition** for reusable stateful logic
- **Context providers** for dependency injection

## Tech Stack

- **Frontend**: React with TypeScript
- **Backend**: Node.js with Express
- **Database**: MongoDB
- **File Storage**: Local server storage

## Getting Started

### Prerequisites

- Node.js (v14 or higher)
- MongoDB (local or MongoDB Atlas)

### Installation

1. Clone the repository
2. Install backend dependencies:
   ```bash
   cd backend
   npm install
   ```

3. Install frontend dependencies:
   ```bash
   cd frontend
   npm install
   ```

4. Set up environment variables:
   Create a `.env` file in the backend directory:
   ```
   MONGODB_URI=mongodb://localhost:27017/wanderlog
   PORT=5000
   ```

### Running the Application

1. Start MongoDB (if running locally)

2. Start the backend server:
   ```bash
   cd backend
   npm run dev
   ```

3. Start the frontend development server:
   ```bash
   cd frontend
   npm start
   ```

4. Open your browser and navigate to `http://localhost:3000`

## API Endpoints

- `POST /api/posts` - Create a new post (with optional image uploads)
- `GET /api/posts` - Get all posts (sorted by creation date, newest first)
- `GET /api/posts/:id` - Get a specific post by UUID

## Project Structure

```
wanderlog/
├── backend/
│   ├── models/
│   │   └── Post.js
│   ├── uploads/          # Image storage directory
│   ├── server.js
│   ├── package.json
│   └── .env
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   │   ├── About.tsx        # Project documentation component
│   │   │   ├── CreateNew.tsx    # Post creation wrapper
│   │   │   ├── CreatePost.tsx   # Post creation form
│   │   │   ├── PostCard.tsx     # Post preview component
│   │   │   ├── PostDetail.tsx   # Full post view
│   │   │   ├── SearchBar.tsx    # Real-time search component
│   │   │   └── Square.tsx       # Main posts grid view
│   │   ├── contexts/
│   │   │   ├── SearchContext.tsx  # Global search state management
│   │   │   └── ThemeContext.tsx   # Dark/light theme management
│   │   ├── hooks/
│   │   │   └── useDebounce.ts     # Custom debounce hook
│   │   ├── types.ts
│   │   ├── App.tsx
│   │   └── App.css
│   └── package.json
├── deployment-guide.md   # Server deployment instructions
├── deploy.sh            # Automated deployment script
├── update.sh            # Application update script
├── LICENSE              # MIT License
└── README.md
```