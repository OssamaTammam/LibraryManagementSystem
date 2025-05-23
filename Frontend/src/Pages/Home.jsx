import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import backgroundImage from "../../utils/backgroundHome.jpg";
import { getallBooks } from "../../api/books";

function BookCard({ book }) {
  return (
    <Link
      to={`/books/${book.id}`}
      className="bg-white rounded-lg shadow-md overflow-hidden flex max-w-[400px] h-[220px] hover:shadow-lg transition-shadow focus:outline-none focus:ring-2 focus:ring-blue-500"
    >
      <div className="p-4 flex flex-col justify-center">
        <h2 className="text-xl font-semibold">{book.title}</h2>
        <p className="text-gray-600">{book.author}</p>
        <p className="text-gray-600">ISBN: {book.isbn}</p>
        <p className="text-gray-600">Borrow Price: {book.borrow_price}$</p>
        <p className="text-gray-600">Buy Price: {book.buy_price}$</p>
        <p className="text-gray-600">Quantity: {book.quantity}</p>
      </div>
    </Link>
  );
}

export default function Home() {
  const [books, setBooks] = useState([]);
  const [isLoggedIn, setIsLoggedIn] = useState(false);

  // Fetch books from backend
  useEffect(() => {
    const fetchBooks = async () => {
      try {
        const data = await getallBooks();
        setBooks(data.books);
      } catch (error) {
        console.error("Failed to fetch books:", error);
      }
    };
    fetchBooks();
    // checkCookies();
  }, []);
  const checkCookies = () => {
    const cookies = document.cookie.split("; ");
    const isLoggedInCookie = cookies.find((cookie) =>
      cookie.startsWith("jwt=")
    );
    if (isLoggedInCookie) {
      setIsLoggedIn(true);
    }
  };

  return (
    <main
      className="min-h-screen p-6 relative"
      style={{
        backgroundImage: `url(${backgroundImage})`,
        backgroundSize: "cover",
        backgroundPosition: "center",
      }}
    >
      {/* Header with Search and Auth Buttons */}
      <header className="bg-white bg-opacity-80 backdrop-blur-md shadow-md px-6 py-4 rounded-lg mb-8 flex items-center justify-between">
        <h1 className="text-2xl font-bold text-gray-900">📚 Library System</h1>

        {/* Auth or Profile */}
        <div className="space-x-4 flex items-center">
          {isLoggedIn ? (
            <div className="flex items-center space-x-2">
              <img
                src="https://www.svgrepo.com/show/382106/profile-user.svg"
                alt="Profile"
                className="w-8 h-8 rounded-full"
              />
              <span className="text-gray-900 font-medium">
                {localStorage.getItem.username}
              </span>
            </div>
          ) : (
            <>
              <Link
                to="/login"
                className="text-gray-900 hover:underline font-medium"
              >
                Login
              </Link>
              <Link
                to="/signup"
                className="bg-gray-900 text-white px-4 py-2 rounded-md hover:bg-gray-700 transition"
              >
                Sign Up
              </Link>
            </>
          )}
        </div>
      </header>

      {/* Books Grid */}
      <section className="flex justify-center">
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6 max-w-6xl w-full">
          {books.map((book) => (
            <article key={book.id}>
              <BookCard book={book} />
            </article>
          ))}
        </div>
      </section>
    </main>
  );
}
