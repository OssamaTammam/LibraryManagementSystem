import axios from "axios";

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
  timeout: 10000, // optional
  withCredentials: true, // optional
  headers: {
    "Content-Type": "application/json",
  },
});

export default api;
