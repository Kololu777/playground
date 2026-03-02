/**
 * React App component - TSX example
 */

import React, { useState, useEffect } from "react";

// TODO: Add error boundary component
// TODO: Implement dark mode toggle

interface AppProps {
  title?: string;
}

interface CounterState {
  count: number;
  lastUpdated: Date | null;
}

const App: React.FC<AppProps> = ({ title = "Ripgrep Practice" }) => {
  const [counter, setCounter] = useState<CounterState>({
    count: 0,
    lastUpdated: null,
  });
  const [isLoading, setIsLoading] = useState<boolean>(false);

  useEffect(() => {
    console.log(`App mounted with title: ${title}`);
  }, [title]);

  const handleIncrement = () => {
    setCounter({
      count: counter.count + 1,
      lastUpdated: new Date(),
    });
  };

  const handleReset = () => {
    setCounter({ count: 0, lastUpdated: null });
  };

  if (isLoading) {
    return <div className="loading">Loading...</div>;
  }

  return (
    <div className="app">
      <h1>{title}</h1>
      <div className="counter">
        <p>Count: {counter.count}</p>
        {counter.lastUpdated && (
          <p>Last updated: {counter.lastUpdated.toLocaleString()}</p>
        )}
        <button onClick={handleIncrement}>Increment</button>
        <button onClick={handleReset}>Reset</button>
      </div>
    </div>
  );
};

export default App;
