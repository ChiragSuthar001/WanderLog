import React from 'react';
import CreatePost from './CreatePost';

interface CreateNewProps {
  onPostCreated: () => void;
}

const CreateNew: React.FC<CreateNewProps> = React.memo(({ onPostCreated }) => {
  return (
    <div className="create-new-container">
      <CreatePost onPostCreated={onPostCreated} />
    </div>
  );
});

CreateNew.displayName = 'CreateNew';

export default CreateNew;