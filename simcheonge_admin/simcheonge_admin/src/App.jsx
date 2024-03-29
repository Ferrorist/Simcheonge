import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import "./App.css";
import Home from "./pages/Home";
import PolicyModify from "./pages/PolicyElement";

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/modify/:policyId" element={<PolicyModify />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
