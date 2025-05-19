class Api::V1::BooksController < Api::ApplicationController
  def index
    authorize Book, :index?
    books = list(Book)
    render_success({ books: serializer(books) })
  end

  def show
    authorize Book, :show?
    book = Book.find!(params[:id])
    render_success({ book: serializer(book) })
  end

  def create
    authorize Book, :create?
    book = Book.create!(book_params)
    render_success({ book: serializer(book) }, :created)
  end

  def update
    authorize Book, :update?
    book = Book.find!(params[:id])
    book.update!(book_params)
    render_success({ book: serializer(book) })
  end

  def destroy
    authorize Book, :destroy?
    book = Book.find!(params[:id])
    book.destroy!
    render_success({ message: "Book deleted successfully" }, :no_content)
  end

  private

  def book_params
    params.permit(:title, :author,  :isbn, :quantity, :buy_price, :borrow_price)
  end
end
