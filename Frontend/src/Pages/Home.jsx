import { useState } from "react";
import { Link } from "react-router-dom";

export default function Home() {
  const [books, setBooks] = useState([
    {
      id: 1,
      title: "Placeholder Book",
      author: "Author Name",
      description: "This is a placeholder book description.",
      coverUrl: "https://via.placeholder.com/150x220?text=Book+Cover",
    },
  ]);

  return (
    <div className="min-h-screen bg-gray-100 p-6 flex justify-center">
      <div className="grid grid-cols-1 gap-6 max-w-5xl w-full">
        {books.map((book) => (
          <Link
            to={`/books/${book.id}`}
            key={book.id}
            className="bg-white rounded-lg shadow-md overflow-hidden flex max-w-[400px] h-[220px] hover:shadow-lg transition-shadow"
          >
            <img
              src={book.coverUrl}
              alt={`${book.title} cover`}
              className="w-36 object-cover"
            />
            <div className="p-4 flex flex-col justify-center">
              <h2 className="text-xl font-semibold">{book.title}</h2>
              <p className="text-gray-600">{book.author}</p>
              <p className="text-gray-700 mt-2 text-sm">{book.description}</p>
            </div>
          </Link>
        ))}
      </div>
    </div>
  );
}
