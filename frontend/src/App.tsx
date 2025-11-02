import React, { useState } from 'react';
import './App.css';
import Square from './components/Square';
import CreateNew from './components/CreateNew';
import About from './components/About';
import { ThemeProvider, useTheme } from './contexts/ThemeContext';
import { SearchProvider } from './contexts/SearchContext';

type TabType = 'square' | 'create' | 'about';

const AppContent: React.FC = () => {
  const [activeTab, setActiveTab] = useState<TabType>('square');
  const [refreshKey, setRefreshKey] = useState(0);
  const { theme, toggleTheme } = useTheme();

  const handlePostCreated = () => {
    setRefreshKey(prev => prev + 1);
    setActiveTab('square'); // Switch to square tab after creating a post
  };

  const renderContent = () => {
    switch (activeTab) {
      case 'square':
        return <Square key={refreshKey} />;
      case 'create':
        return <CreateNew onPostCreated={handlePostCreated} />;
      case 'about':
        return <About />;
      default:
        return <Square key={refreshKey} />;
    }
  };

  return (
    <div className="App">
      <header className="header">
        <div className="header-top">
          <h1>WanderLog</h1>
          <div className="header-actions">
            <button 
              className="theme-toggle"
              onClick={toggleTheme}
              aria-label={`Switch to ${theme === 'light' ? 'dark' : 'light'} theme`}
            >
              {theme === 'light' ? '🌙' : '☀️'}
            </button>
            <a 
              href="https://github.com/ShakyVertex/WanderLog" 
              target="_blank" 
              rel="noopener noreferrer"
              className="github-button"
            >
              GitHub
            </a>
          </div>
        </div>
        <nav className="tab-navigation">
          <button 
            className={`tab-button ${activeTab === 'square' ? 'active' : ''}`}
            onClick={() => setActiveTab('square')}
          >
            Square
          </button>
          <button 
            className={`tab-button ${activeTab === 'create' ? 'active' : ''}`}
            onClick={() => setActiveTab('create')}
          >
            Create New
          </button>
          <button 
            className={`tab-button ${activeTab === 'about' ? 'active' : ''}`}
            onClick={() => setActiveTab('about')}
          >
            About
          </button>
        </nav>
      </header>
      
      <div className="container">
        {renderContent()}
      </div>
    </div>
  );
};

function App() {
  return (
    <ThemeProvider>
      <SearchProvider>
        <AppContent />
      </SearchProvider>
    </ThemeProvider>
  );
}

export default App;
