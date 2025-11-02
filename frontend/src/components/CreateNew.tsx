import React from 'react';
import CreatePost from './CreatePost';

interface CreateNewProps {
  onPostCreated: () => void;
}

const CreateNew: React.FC<CreateNewProps> = ({ onPostCreated }) => {
  return (
    <div className="create-new-container">
      <CreatePost onPostCreated={onPostCreated} />
    </div>
  );
};

export default CreateNew;