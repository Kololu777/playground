import React, { useState, useEffect } from "react";
import { Header } from "./Header";
import { Button } from "./Button";

interface AppProps {
  title?: string;
}

export function App({ title = "fd Practice" }: AppProps) {
  const [count, setCount] = useState(0);
  const [isReady, setIsReady] = useState(false);

  useEffect(() => {
    console.log("App mounted");
    setIsReady(true);
    return () => console.log("App unmounted");
  }, []);

  if (!isReady) {
    return <div className="loading">Initializing...</div>;
  }

  return (
    <div className="app">
      <Header title={title} />
      <main>
        <p>Count: {count}</p>
        <Button label="Increment" onClick={() => setCount((c) => c + 1)} />
        <Button label="Reset" onClick={() => setCount(0)} />
      </main>
    </div>
  );
}
