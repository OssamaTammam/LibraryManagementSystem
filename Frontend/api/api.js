import axios from 'axios';

const api = axios.create({
  baseURL: process.env.REACT_APP_API_URL, // from .env file
  timeout: 10000, // optional
  withCredentials: true, // optional
  headers: {
    'Content-Type': 'application/json',
  },
});

export default api;