// tailwind.config.js
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html", // Main HTML file
    "./src/**/*.{js,jsx,ts,tsx}", // All JS/TS/JSX/TSX files in the src folder
  ],
  theme: {
    extend: {
      colors: {
        orange: "#fd8524",
        orangeLight: "#f2933f",
        babyBlue: "#40cad0",
        navyBlue: "#191f2a",
        
      },
    },
  },
  plugins: [],
};
