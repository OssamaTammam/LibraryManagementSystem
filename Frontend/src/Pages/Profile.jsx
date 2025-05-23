import { useState, useEffect } from "react";
import { getMyBorrowedBooks } from "../../api/books";
import backgroundImage from "../../utils/backgroundHome.jpg";
import { Link } from "react-router-dom";
import { returnBook } from "../../api/books";
import { getMyTransactions } from "../../api/users";

export default function Profile() {
  const [borrowedBooks, setBorrowedBooks] = useState([]);

  useEffect(() => {
    const fetchBorrowedBooks = async () => {
      try {
        const data = await getMyBorrowedBooks();
        setBorrowedBooks(data);
      } catch (error) {
        console.error("Failed to fetch borrowed books:", error);
      }
    };

    fetchBorrowedBooks();
  }, []);

  const handleReturn = async (book) => {
    try {
      const transactions = await getMyTransactions();

      const matchingTransaction = transactions.find(
        (tx) => tx.book_id === book.book_id
      );

      if (!matchingTransaction) {
        console.warn("No matching transaction found for this book.");
        return;
      }

      await returnBook({
        id: book.book_id,
        transaction_id: matchingTransaction.id,
      });

      // Optionally update UI after return
      setBorrowedBooks((prev) =>
        prev.filter((b) => b.book_id !== book.book_id)
      );
    } catch (error) {
      console.error("Failed to return book:", error);
    }
  };

  return (
    <main
      className="min-h-screen p-6"
      style={{
        backgroundImage: `url(${backgroundImage})`,
        backgroundSize: "cover",
        backgroundPosition: "center",
      }}
    >
      <h1 className="text-3xl font-bold text-white mb-6">My Borrowed Books</h1>

      <div className="space-y-4">
        {borrowedBooks.length === 0 ? (
          <p className="text-white">You haven't borrowed any books yet.</p>
        ) : (
          borrowedBooks.map((book) => (
            <div
              key={book.id}
              className="bg-white bg-opacity-90 rounded-lg shadow-md p-4 flex justify-between items-center"
            >
              <div>
                <h2 className="text-xl font-semibold text-gray-800">
                  {book.title}
                </h2>
                <p className="text-gray-600">By {book.author}</p>
                <p className="text-gray-700 text-sm mt-2">
                  Borrowed on: {new Date(book.borrowed_at).toLocaleDateString()}
                </p>
                <p className="text-gray-700 text-sm">
                  Due on: {new Date(book.due_date).toLocaleDateString()}
                </p>
              </div>
              <div className="flex flex-col space-y-2 items-end">
                <Link
                  to={`/books/${book.book_id}`}
                  className="text-blue-600 font-medium hover:underline"
                >
                  View Book
                </Link>
                <button
                  onClick={() => handleReturn(book)}
                  className="bg-red-600 text-white px-4 py-1 rounded hover:bg-red-700 transition"
                >
                  Return
                </button>
              </div>
            </div>
          ))
        )}
      </div>
    </main>
  );
}
