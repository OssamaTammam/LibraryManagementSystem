import { Routes, Route } from "react-router-dom";
import Login from "./Pages/Login";
import SignUp from "./Pages/Signup";
import Home from "./Pages/Home";
import "./index.css";
import BookPage from "./Pages/Book";
import Profile from "./Pages/Profile";

function App() {
  return (
    <Routes>
      <Route path="/" element={<Home />} />
      <Route path="/login" element={<Login />} />
      <Route path="/signup" element={<SignUp />} />
      <Route path="/books/:id" element={<BookPage />} />
      <Route path="/profile" element={<Profile />} />
    </Routes>
  );
}

export default App;
