import api from "./api";

export const signin = async (signinData) => {
  try {
    const response = await api.post("/auth/signin", signinData);
    return response.data;
  } catch (error) {
    console.error("Login error:", error.request);
  }
};

export const signup = async (signupData) => {
  try {
    const response = await api.post("/auth/signup", signupData);
    return response.data;
  } catch (error) {
    console.error("Signup error:", error.request);
    throw error;
  }
};
