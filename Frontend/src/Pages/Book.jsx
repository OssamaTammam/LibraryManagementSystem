import { useParams } from "react-router-dom";
import imageCover from "../../utils/book.png";
import backgroundImage from "../../utils/backgroundHome.jpg";

export default function BookPage() {
  const { id } = useParams();

  const book = {
    id,
    title: "Harry Potter and the Cursed Child",
    author: "J.K. Rowling, Jack Thorne, and John Tiffany",
    description:
      "Based on an original new story by J.K. Rowling, Jack Thorne, and John Tiffany, 'Harry Potter and the Cursed Child' is a stage play that follows Harry Potter’s son, Albus Severus Potter, as he grapples with the weight of a family legacy he never wanted. As past and present fuse ominously, father and son learn the uncomfortable truth: sometimes, darkness comes from unexpected places.",
    coverUrl: imageCover,
    genres: ["Fantasy", "Play", "Harry Potter", "Magic", "Adventure"],
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
        {/* Left: Cover Image */}
        <div className="md:w-1/2 w-full h-80 md:h-auto">
          <img
            src={book.coverUrl}
            alt={`${book.title} cover`}
            className="w-full h-full object-cover"
          />
        </div>

        {/* Right: Book Info */}
        <div className="md:w-1/2 w-full p-6 flex flex-col justify-center">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">
            {book.title}
          </h1>
          <h2 className="text-xl text-gray-700 mb-4">by {book.author}</h2>
          <p className="text-gray-800 mb-6 leading-relaxed">
            {book.description}
          </p>

          <div className="flex flex-wrap gap-2">
            {book.genres.map((genre, idx) => (
              <span
                key={idx}
                className="bg-blue-100 text-blue-800 px-3 py-1 text-sm rounded-full"
              >
                {genre}
              </span>
            ))}
          </div>
        </div>
      </div>
    </main>
  );
}
