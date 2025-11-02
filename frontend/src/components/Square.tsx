import React, { useState, useEffect } from 'react';
import PostCard from './PostCard';
import PostDetail from './PostDetail';
import { Post } from '../types';

interface SquareProps {
  onRefresh?: () => void;
}

const Square: React.FC<SquareProps> = ({ onRefresh }) => {
  const [posts, setPosts] = useState<Post[]>([]);
  const [selectedPost, setSelectedPost] = useState<Post | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchPosts = async () => {
    try {
      setLoading(true);
      const response = await fetch('http://localhost:5001/api/posts');
      if (response.ok) {
        const data = await response.json();
        setPosts(data);
        setError(null);
      } else {
        setError('Failed to fetch posts');
      }
    } catch (err) {
      setError('Failed to fetch posts');
      console.error('Error fetching posts:', err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchPosts();
  }, []);

  const handlePostClick = (post: Post) => {
    setSelectedPost(post);
  };

  const handleBackToList = () => {
    setSelectedPost(null);
  };

  if (selectedPost) {
    return <PostDetail post={selectedPost} onBack={handleBackToList} />;
  }

  return (
    <div className="square-container">
      {error && <div className="error">{error}</div>}
      
      {loading ? (
        <div className="loading">Loading posts...</div>
      ) : (
        <div className="posts-grid">
          {posts.length === 0 ? (
            <div style={{ textAlign: 'center', padding: '2rem', color: '#666' }}>
              No posts yet. Create the first one in the "Create New" tab!
            </div>
          ) : (
            posts.map((post) => (
              <PostCard
                key={post.id}
                post={post}
                onClick={() => handlePostClick(post)}
              />
            ))
          )}
        </div>
      )}
    </div>
  );
};

export default Square;