import { useParams } from "react-router-dom";
import { useEffect, useState } from "react";
import backgroundImage from "../../utils/backgroundHome.jpg";
import { borrowBook } from "../../api/books";
import { buyBook } from "../../api/books";
import { getBookById } from "../../api/books";

export default function BookPage() {
  const { id } = useParams();
  const [book, setBook] = useState({});

  useEffect(() => {
    const fetchBook = async () => {
      const data = await getBookById(id);

      setBook(data.book);
    };

    fetchBook();
  }, [id]);

  const handleBorrow = async () => {
    const days = prompt("Enter number of days to borrow:");
    try {
      const res = await borrowBook({ id, days });
      book.quantity -= 1;
      setBook({ ...book });
      alert("Book borrowed successfully!");
    } catch (error) {
      alert("Failed to borrow book.");
    }
  };
  const handleBuy = async () => {
    try {
      const res = await buyBook({ id });
      book.quantity -= 1;
      setBook({ ...book });
      alert("Book bought successfully!");
    } catch (error) {
      alert("Failed to buy book.");
    }
  };

  return (
    <main
      className="min-h-screen p-8 flex justify-center items-center"
      style={{
        backgroundImage: `url(${backgroundImage})`,
        backgroundSize: "cover",
        backgroundPosition: "center",
        backgroundRepeat: "no-repeat",
      }}
    >
      <div className="bg-white bg-opacity-90 backdrop-blur-sm rounded-lg shadow-lg max-w-5xl w-full flex flex-col md:flex-row overflow-hidden">
        {/* Left: Book Info */}
        <div className="md:w-1/2 w-full p-6 flex flex-col justify-center">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">
            {book.title}
          </h1>
          <h2 className="text-xl text-gray-700 mb-4">by {book.author}</h2>
          <p className="text-gray-800 mb-6 leading-relaxed">
            ISBN: {book.isbn} <br />
            Borrow Price: {book.borrow_price}$ <br />
            Buy Price: {book.buy_price}$ <br />
            Quantity: {book.quantity}
          </p>
        </div>

        {/* Right: Buttons on bottom-right */}
        <div className="md:w-1/2 w-full p-6 flex flex-col justify-between">
          <div className="flex-grow" />
          <div className="flex justify-end space-x-4">
            <button
              className="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 transition"
              onClick={handleBorrow}
            >
              Borrow
            </button>
            <button
              onClick={handleBuy}
              className="bg-green-600 text-white px-6 py-2 rounded-md hover:bg-green-700 transition"
            >
              Buy
            </button>
          </div>
        </div>
      </div>
    </main>
  );
}
