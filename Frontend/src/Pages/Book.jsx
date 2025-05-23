import { useParams } from "react-router-dom";
import { useEffect, useState } from "react";
import backgroundImage from "../../utils/backgroundHome.jpg";
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
        <div className="md:w-1/2 w-full p-6 flex flex-col justify-center">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">
            {book.title}
          </h1>
          <h2 className="text-xl text-gray-700 mb-4">by {book.author}</h2>
          <p className="text-gray-800 mb-6 leading-relaxed"></p>
          <p className="text-gray-800 mb-6 leading-relaxed">
            ISBN: {book.isbn} <br />
            Borrow Price: {book.borrow_price}$ <br />
            Buy Price: {book.buy_price}$ <br />
            Quantity: {book.quantity}
          </p>
        </div>
      </div>
    </main>
  );
}
