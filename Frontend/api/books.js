import api from "./api";

export const getallBooks = async () => {
  try {
    const response = await api.get("/books");
    return response.data;
  } catch (error) {
    console.error("Error fetching books:", error);
    throw error;
  }
};
export const getBookById = async (id) => {
  try {
    const response = await api.get(`/books/${id}`);
    return response.data;
  } catch (error) {
    console.error("Error fetching book:", error);
    throw error;
  }
};
export const createBook = async (bookData) => {
  try {
    const response = await api.post("/books", bookData);
    return response.data;
  } catch (error) {
    console.error("Error creating book:", error);
    throw error;
  }
};
export const updateBook = async (id, bookData) => {
  try {
    const response = await api.put(`/books/${id}`, bookData);
    return response.data;
  } catch (error) {
    console.error("Error updating book:", error);
    throw error;
  }
};
export const deleteBook = async (id) => {
  try {
    const response = await api.delete(`/books/${id}`);
    return response.data;
  } catch (error) {
    console.error("Error deleting book:", error);
    throw error;
  }
};

export const borrowBook = async (bookData) => {
  try {
    const response = await api.post("books/borrow", {
      book_id: bookData.id,
      days: bookData.days,
    });
    return response.data;
  } catch (error) {
    console.error("Error borrowing book:", error);
    throw error;
  }
};

export const buyBook = async (bookData) => {
  try {
    const response = await api.post("books/buy", {
      book_id: bookData.id,
    });
    return response.data;
  } catch (error) {
    console.error("Error buying book:", error);
    throw error;
  }
};

export const returnBook = async (bookData) => {
  try {
    const response = await api.post("books/return", {
      book_id: bookData.id,
      transaction_id: bookData.transaction_id,
    });
    return response.data;
  } catch (error) {
    console.error("Error returning book:", error);
    throw error;
  }
};
