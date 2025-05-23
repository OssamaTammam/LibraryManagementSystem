import { useState, useEffect } from "react";
import { getMyBorrowedBooks, getMyTransactions } from "../../api/users";
import { returnBook } from "../../api/books";
import backgroundImage from "../../utils/backgroundHome.jpg";
import { Link } from "react-router-dom";

export default function Profile() {
  const [borrowTransactions, setBorrowTransactions] = useState([]);

  const toReadableDate = (rawDate) => {
    const iso = rawDate.replace(" ", "T"); // "2025-05-23T20:06:22.349145000+0000"
    return new Date(iso).toLocaleDateString();
  };

  useEffect(() => {
    const fetchBorrowTransactions = async () => {
      try {
        const data = await getMyBorrowedBooks();
        setBorrowTransactions(data.transactions);
      } catch (error) {
        console.error("Failed to fetch borrowed books:", error);
      }
    };

    fetchBorrowTransactions();
  }, []);

  const handleReturn = async (transaction) => {
    try {
      await returnBook({
        id: transaction.book.book_id,
        transaction_id: transaction.transaction_id,
      });

      // Update UI after return
      setBorrowTransactions((prev) =>
        prev.filter((t) => t.transaction_id !== transaction.transaction_id)
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
        {borrowTransactions.length === 0 ? (
          <p className="text-white">You haven't borrowed any books yet.</p>
        ) : (
          borrowTransactions.map((transaction) => (
            <div
              key={transaction.transaction_id}
              className="bg-white bg-opacity-90 rounded-lg shadow-md p-4 flex justify-between items-center"
            >
              <div>
                <h2 className="text-xl font-semibold text-gray-800">
                  {transaction.book.title}
                </h2>
                <p className="text-gray-700 text-sm mt-2">
                  Borrowed on: {toReadableDate(transaction.borrowed_at)}
                </p>
                <p className="text-gray-700 text-sm">
                  Due on: {toReadableDate(transaction.due_date)}
                </p>{" "}
              </div>
              <div className="flex flex-col space-y-2 items-end">
                <Link
                  to={`/books/${transaction.book.book_id}`}
                  className="text-blue-600 font-medium hover:underline"
                >
                  View Book
                </Link>
                <button
                  onClick={() => handleReturn(transaction)}
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
